#!/usr/bin/env bash
# step 0: github access + git identity.
#
# this is the chicken-and-egg step of the whole bootstrap — everything else
# needs the repo, and the repo needs github access. so this script is written
# to be runnable standalone, straight off a raw github URL, before any clone:
#
#   bash <(curl -fsSL https://raw.githubusercontent.com/MinhTriet-TO/dotfiles/main/install/bootstrap/github.sh)
#
# it therefore must not depend on anything else in the repo.
#
# what it does NOT do: add the public key to github. that needs an authenticated
# session, so the script prints the key and hands off. adding it is 10 seconds
# of clicking and it only happens once per machine.

set -euo pipefail

# --- standalone-safe logging (no common.sh, see above) -----------------------
if [ -t 1 ]; then
  _b=$'\033[1;34m'; _g=$'\033[1;32m'; _y=$'\033[1;33m'; _d=$'\033[2m'; _r=$'\033[0m'
else
  _b=''; _g=''; _y=''; _d=''; _r=''
fi
log()  { printf '%s==>%s %s\n' "$_b" "$_r" "$*"; }
ok()   { printf '%s  ✓%s %s\n' "$_g" "$_r" "$*"; }
skip() { printf '%s  ·%s %s\n' "$_d" "$_r" "$*"; }
warn() { printf '%s  !%s %s\n' "$_y" "$_r" "$*" >&2; }
die()  { printf '  ✗ %s\n' "$*" >&2; exit 1; }

KEY="$HOME/.ssh/id_ed25519"
SSH_CONFIG="$HOME/.ssh/config"
GIT_LOCAL="$HOME/.gitconfig.local"

# `ssh -T git@github.com` always exits 1 — github grants no shell, so success
# is only visible in the greeting text. that exit code combined with pipefail
# makes the obvious `ssh ... | grep -q` spelling report a false failure, hence
# capturing the output first.
github_authenticated() {
  local out
  out="$(ssh -o BatchMode=yes -o StrictHostKeyChecking=accept-new -T git@github.com 2>&1 || true)"
  printf '%s' "$out" | grep -q 'successfully authenticated'
}

[ "$(uname -s)" = "Darwin" ] || die "macOS only"

# --- 1. command line tools ---------------------------------------------------
# a fresh mac has no git and no make, both come from the CLT. the installer is
# a GUI prompt, so we can only kick it off and wait for the user.
log "xcode command line tools"
if xcode-select -p >/dev/null 2>&1; then
  skip "already installed"
else
  warn "installing — accept the dialog, then re-run this script"
  xcode-select --install || true
  exit 1
fi

# --- 2. ssh key --------------------------------------------------------------
log "ssh key"
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

# the key comment is just a label; use the git email so keys are identifiable
# in github's UI when several machines are enrolled.
GIT_EMAIL="${GIT_EMAIL:-$(git config --file "$GIT_LOCAL" user.email 2>/dev/null || git config --global user.email 2>/dev/null || true)}"
if [ -z "$GIT_EMAIL" ]; then
  read -rp "  git email for this machine: " GIT_EMAIL
  [ -n "$GIT_EMAIL" ] || die "an email is required"
fi

if [ -f "$KEY" ]; then
  skip "$KEY already exists"
else
  # no passphrase: the objective is a friction-free bootstrap, and the key is
  # protected by the login keychain + filevault. set SSH_PASSPHRASE to override.
  ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$KEY" -N "${SSH_PASSPHRASE:-}"
  ok "generated $KEY"
fi
chmod 600 "$KEY"

# --- 3. ssh config -----------------------------------------------------------
# UseKeychain + AddKeysToAgent are what make the key survive a reboot on macOS,
# which is the difference between doing this once and doing it every morning.
log "ssh config"
touch "$SSH_CONFIG"
chmod 600 "$SSH_CONFIG"
if grep -qE '^[[:space:]]*Host[[:space:]]+github\.com[[:space:]]*$' "$SSH_CONFIG"; then
  skip "github.com block already present"
else
  # appended, never rewritten — this file often has other includes in it
  cat >> "$SSH_CONFIG" <<EOF

Host github.com
  HostName github.com
  User git
  IdentityFile $KEY
  AddKeysToAgent yes
  UseKeychain yes
EOF
  ok "added github.com block"
fi

ssh-add --apple-use-keychain "$KEY" >/dev/null 2>&1 \
  && ok "key loaded into the agent + keychain" \
  || warn "could not add the key to the agent (harmless if it's already there)"

# --- 4. hand off the public key ----------------------------------------------
log "add this key to github"
if github_authenticated; then
  ok "already authenticated to github — nothing to paste"
else
  pbcopy < "$KEY.pub"
  ok "public key copied to clipboard"
  echo "     paste it at https://github.com/settings/ssh/new"
  echo
  cat "$KEY.pub"
  echo
  # only block on a human when there is one — otherwise this would hang (or
  # read EOF and fail) in a VM test run or any non-interactive bootstrap
  if [ -t 0 ]; then
    read -rp "  press enter once the key is added… "
    if github_authenticated; then
      ok "authenticated to github"
    else
      die "still cannot authenticate — check the key was added to the right account"
    fi
  else
    warn "not a terminal, so not waiting — add the key, then re-run to confirm"
  fi
fi

# --- 5. git identity --------------------------------------------------------
# identity is per-machine (work email vs personal), so it lives in
# ~/.gitconfig.local which the repo's .gitconfig includes but never contains.
# that's what lets one committed .gitconfig serve both machines.
log "git identity"
if [ -f "$GIT_LOCAL" ]; then
  skip "$GIT_LOCAL already exists"
else
  # carry over anything already configured globally so signing keeps working
  name="$(git config --global user.name 2>/dev/null || true)"
  signingkey="$(git config --global user.signingkey 2>/dev/null || true)"
  gpgsign="$(git config --global commit.gpgsign 2>/dev/null || true)"
  if [ -z "$name" ]; then
    read -rp "  git name: " name
  fi

  {
    echo "# machine-local git identity. not committed: the email differs between"
    echo "# work and personal machines, and the signing key is per-keyring."
    echo "[user]"
    echo "    name = $name"
    echo "    email = $GIT_EMAIL"
    [ -n "$signingkey" ] && echo "    signingkey = $signingkey"
    if [ -n "$gpgsign" ]; then
      echo "[commit]"
      echo "    gpgsign = $gpgsign"
    fi
  } > "$GIT_LOCAL"
  ok "wrote $GIT_LOCAL (name=$name, email=$GIT_EMAIL)"
  [ -n "$signingkey" ] && ok "carried over signing key $signingkey"
fi

echo
ok "github access ready"
echo "     still pending (handled by 'make link'): ~/.gitconfig and ~/.gitignore"
