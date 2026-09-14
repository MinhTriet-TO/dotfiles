#!/usr/bin/env bash
# checkhealth — is this machine actually set up, and does it still work?
#
# the install scripts answer "did I install it". this answers "is it wired up
# correctly right now", which is the thing that rots: a symlink replaced by a
# real file, a plugin dir deleted, a config that no longer parses, PATH losing
# an entry after an edit.
#
# every check keeps going after a failure so one run gives the full picture.
# exits non-zero if anything FAILED; warnings alone still exit 0, because they
# flag things that are legitimately optional or machine-local.

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.sh"

# checks must not abort the run
set +e

FAILED=0
WARNED=0

section() { printf '\n%s==>%s %s\n' "$_blue" "$_reset" "$*"; }

# check "label" command...
check() {
  local label="$1"; shift
  if "$@" >/dev/null 2>&1; then
    ok "$label"
  else
    fail "$label"
    FAILED=$((FAILED + 1))
  fi
}

# same, but a failure is advisory rather than broken
check_warn() {
  local label="$1"; shift
  if "$@" >/dev/null 2>&1; then
    ok "$label"
  else
    warn "$label"
    WARNED=$((WARNED + 1))
  fi
}

# a symlink is only healthy if it still points *into the repo* — an existing
# file at the path proves nothing, since that's exactly what drift looks like.
check_link() {
  local dest="$1" want="$REPO_ROOT/$2" short="~${1#$HOME}"
  if [ ! -L "$dest" ]; then
    if [ -e "$dest" ]; then
      fail "$short is a real file, not a link to the repo"
    else
      fail "$short is missing"
    fi
    FAILED=$((FAILED + 1))
    return
  fi
  if [ "$(readlink "$dest")" = "$want" ]; then
    ok "$short"
  else
    fail "$short -> $(readlink "$dest") (expected $want)"
    FAILED=$((FAILED + 1))
  fi
}

app_installed() { [ -d "/Applications/$1" ]; }

require_macos
MACHINE="${MACHINE:-$(bash "$REPO_ROOT/install/lib/machine.sh")}"

printf '%s==>%s dotfiles checkhealth — machine looks like: %s\n' "$_blue" "$_reset" "$MACHINE"

# --- symlinks ----------------------------------------------------------------
section "symlinks"
check_link "$HOME/.gitconfig"    ".gitconfig"
check_link "$HOME/.gitignore"    "git/gitignore.global"
check_link "$HOME/.zshrc"        ".zshrc"
check_link "$HOME/.p10k.zsh"     ".p10k.zsh"
check_link "$HOME/.zsh_secrets"  ".zsh_secrets"
check_link "$HOME/.tmux.conf"    ".tmux.conf"
check_link "$HOME/.wezterm.lua"  ".wezterm.lua"
check_link "$HOME/.config/nvim"  "nvim"

# --- git ---------------------------------------------------------------------
section "git"
# note: `git config --global` defaults --includes to OFF, so it would not see
# the identity at all. plain `git config` is how git itself resolves it.
check "identity resolves ($(git config user.email 2>/dev/null || echo 'none'))" \
  bash -c '[ -n "$(git config user.email)" ] && [ -n "$(git config user.name)" ]'
check "aliases loaded from the repo gitconfig" \
  bash -c '[ "$(git config --get-regexp "^alias" | wc -l)" -gt 0 ]'
check "global ignore active" bash -c '[ -n "$(git config core.excludesfile)" ]'
check_warn "commit signing configured" bash -c '[ "$(git config commit.gpgsign)" = "true" ]'

# --- secrets -----------------------------------------------------------------
section "secrets"
check ".zsh_secrets exists in the repo" test -f "$REPO_ROOT/.zsh_secrets"
# never print values — only whether they're still blank
if [ -f "$REPO_ROOT/.zsh_secrets" ]; then
  empty="$(grep -c '^export [A-Z_]*=$' "$REPO_ROOT/.zsh_secrets" 2>/dev/null)"
  if [ "${empty:-0}" -eq 0 ]; then
    ok "all secret values filled in"
  else
    warn "$empty secret(s) still empty — anything needing them will fail"
    WARNED=$((WARNED + 1))
  fi
fi
check ".zsh_secrets is gitignored" \
  bash -c "cd '$REPO_ROOT' && git check-ignore -q .zsh_secrets"
check "no secret values are tracked by git" \
  bash -c "cd '$REPO_ROOT' && ! git ls-files --error-unmatch .zsh_secrets >/dev/null 2>&1"

# --- shell -------------------------------------------------------------------
section "zsh"
check "login shell is zsh" bash -c '[[ "$(dscl . -read "/Users/$USER" UserShell | awk "{print \$2}")" == */zsh ]]'
check "oh-my-zsh installed" test -d "$HOME/.oh-my-zsh"
check "powerlevel10k theme" test -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
check "zsh-autosuggestions" test -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
check "nerd font installed" bash -c 'ls "$HOME/Library/Fonts" 2>/dev/null | grep -qi meslo'
for b in lsd nvim fzf mise uv rg fd tmux; do
  check "$b on PATH" command -v "$b"
done

# the check that catches the nastiest regression: .zshrc must put brew and
# ~/.local/bin on PATH *itself*. inherited PATH hides this, so start from a
# deliberately bare one — that is how a fresh login shell actually looks.
check "zshrc builds its own PATH (brew + ~/.local/bin)" \
  env -i HOME="$HOME" TERM=dumb PATH=/usr/bin:/bin:/usr/sbin:/sbin \
  /bin/zsh -ic 'command -v brew >/dev/null && command -v uv >/dev/null'

# --- wezterm -----------------------------------------------------------------
section "wezterm"
check "WezTerm installed" app_installed "WezTerm.app"
WEZ="/Applications/WezTerm.app/Contents/MacOS/wezterm"
if [ -x "$WEZ" ]; then
  # wezterm validates color_scheme names and option keys, so a clean parse is
  # a real check rather than a formality
  check "config parses (font + colour scheme valid)" \
    bash -c "'$WEZ' --config-file '$REPO_ROOT/.wezterm.lua' ls-fonts 2>&1 | grep -qiv error"
fi

# --- tmux --------------------------------------------------------------------
section "tmux"
check "tpm installed" test -d "$HOME/.tmux/plugins/tpm"
if [ -f "$HOME/.tmux.conf" ]; then
  missing_plugins=0
  while read -r plugin; do
    [ -d "$HOME/.tmux/plugins/${plugin##*/}" ] || missing_plugins=$((missing_plugins + 1))
  done < <(grep -oE "^set -g @plugin '[^']+'" "$HOME/.tmux.conf" | sed "s/.*'\(.*\)'/\1/")
  check "every declared plugin installed" test "$missing_plugins" -eq 0

  # load the config on a private socket so a real session is never touched
  check "config loads" \
    bash -c 'tmux -L healthcheck -f "$HOME/.tmux.conf" new-session -d 2>/dev/null; rc=$?; tmux -L healthcheck kill-server 2>/dev/null; exit $rc'
fi

# --- nvim --------------------------------------------------------------------
section "nvim"
check "nvim starts without errors" bash -c '[ -z "$(nvim --headless +qa 2>&1)" ]'
check "lazy.nvim is the plugin manager" \
  bash -c 'nvim --headless -c "lua assert(pcall(require, \"lazy\"))" +qa 2>/dev/null'
if [ -f "$REPO_ROOT/nvim/lazy-lock.json" ]; then
  pinned="$(grep -c '": {' "$REPO_ROOT/nvim/lazy-lock.json")"
  installed="$(find "$HOME/.local/share/nvim/lazy" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')"
  check "$installed of $pinned pinned plugins installed" test "${installed:-0}" -ge "$pinned"
fi
# telescope's fuzzy matcher is a C extension built by `make`; when it fails to
# build nothing errors, telescope is just silently slower
check "telescope-fzf-native compiled" \
  bash -c 'ls "$HOME/.local/share/nvim/lazy/telescope-fzf-native.nvim/build/"*.so >/dev/null 2>&1'

# --- personal apps -----------------------------------------------------------
section "personal tools"
check "Arc installed" app_installed "Arc.app"
check_warn "Arc signed in (spaces/bookmarks sync from the account)" \
  test -f "$HOME/Library/Application Support/Arc/StorableAuthState.json"
check "VS Code installed" app_installed "Visual Studio Code.app"
if command -v code >/dev/null 2>&1 && [ -f "$REPO_ROOT/vscode/extensions.txt" ]; then
  want="$(grep -cve '^\s*$' -e '^#' "$REPO_ROOT/vscode/extensions.txt")"
  have="$(code --list-extensions 2>/dev/null | wc -l | tr -d ' ')"
  check "$have of $want vscode extensions installed" test "${have:-0}" -ge "$want"
fi

# --- work tools --------------------------------------------------------------
if [ "$MACHINE" = "work" ]; then
  section "work tools"
  check "Slack installed" app_installed "Slack.app"
  check_warn "slack theme captured in the repo" \
    bash -c "grep -q '^SLACK_THEME=\"#' '$REPO_ROOT/slack/theme.conf'"
  check "QGIS installed" bash -c 'ls -d /Applications/QGIS*.app >/dev/null 2>&1'
  check "Cloudflare WARP installed" app_installed "Cloudflare WARP.app"
  # delegate to the existing functional check: it proves traffic really flows
  # through the tunnel, which is the only thing that matters here
  printf '\n'
  if bash "$REPO_ROOT/install/verify/cloudflare.sh" >/dev/null 2>&1; then
    ok "cloudflare warp verified (tunnel carrying traffic)"
  else
    fail "cloudflare warp verification failed — run 'make verify-cloudflare'"
    FAILED=$((FAILED + 1))
  fi
fi

# --- summary -----------------------------------------------------------------
echo
if [ "$FAILED" -eq 0 ] && [ "$WARNED" -eq 0 ]; then
  ok "everything checks out"
  exit 0
fi
if [ "$FAILED" -eq 0 ]; then
  ok "no failures, $WARNED warning(s)"
  exit 0
fi
die "$FAILED check(s) failed, $WARNED warning(s)"
