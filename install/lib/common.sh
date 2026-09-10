#!/usr/bin/env bash
# shared helpers for the install scripts. source this, don't run it:
#   source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"
#
# every install script is expected to be idempotent: running it twice must be
# safe, and the second run should mostly print "skip".

set -euo pipefail

# --- output ------------------------------------------------------------------
# colors only when writing to a terminal, so logs stay clean when piped
if [ -t 1 ]; then
  _blue=$'\033[1;34m'; _green=$'\033[1;32m'; _yellow=$'\033[1;33m'
  _red=$'\033[1;31m'; _dim=$'\033[2m'; _reset=$'\033[0m'
else
  _blue=''; _green=''; _yellow=''; _red=''; _dim=''; _reset=''
fi

log()  { printf '%s==>%s %s\n' "$_blue" "$_reset" "$*"; }
ok()   { printf '%s  ✓%s %s\n' "$_green" "$_reset" "$*"; }
skip() { printf '%s  ·%s %s\n' "$_dim" "$_reset" "$*"; }
warn() { printf '%s  !%s %s\n' "$_yellow" "$_reset" "$*" >&2; }
fail() { printf '%s  ✗%s %s\n' "$_red" "$_reset" "$*" >&2; }
die()  { fail "$*"; exit 1; }

# --- paths -------------------------------------------------------------------
# resolved from this file, so scripts work no matter where they're invoked from
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
export REPO_ROOT

# --- guards ------------------------------------------------------------------
require_macos() {
  [ "$(uname -s)" = "Darwin" ] \
    || die "these scripts target macOS, but this is $(uname -s)"
}

# --- homebrew ----------------------------------------------------------------
# a fresh machine has no brew, and even once installed it isn't on PATH until
# the shell is reloaded — so put it on PATH for the current process too.
ensure_brew() {
  if command -v brew >/dev/null 2>&1; then
    skip "homebrew already on PATH"
    return
  fi

  local prefix
  for prefix in /opt/homebrew /usr/local; do
    if [ -x "$prefix/bin/brew" ]; then
      eval "$("$prefix/bin/brew" shellenv)"
      ok "homebrew found at $prefix"
      return
    fi
  done

  log "installing homebrew"
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  for prefix in /opt/homebrew /usr/local; do
    if [ -x "$prefix/bin/brew" ]; then
      eval "$("$prefix/bin/brew" shellenv)"
      ok "homebrew installed at $prefix"
      return
    fi
  done
  die "homebrew install finished but no brew binary was found"
}

# --- casks -------------------------------------------------------------------
# an app can be present without brew knowing about it (installed by hand, or
# pushed by MDM on a work machine), so check both before deciding to install.
#
# the app name is treated as a glob, because some casks ship a versioned bundle
# rather than a bare one — qgis installs as "QGIS-final-4_2_2.app", so a literal
# "QGIS.app" check never matches and the fallback would be useless.
cask_present() {
  local token="$1" app="${2:-}"
  brew list --cask "$token" >/dev/null 2>&1 && return 0
  if [ -n "$app" ]; then
    local match
    # empty IFS stops word splitting on app names that contain spaces
    # ("Cloudflare WARP.app"), while still letting the glob expand. each hit is
    # then stat'd, because an unmatched pattern with no wildcard is passed
    # through literally — testing only "did it expand" reports false positives.
    local IFS=
    for match in /Applications/$app; do
      [ -d "$match" ] && return 0
    done
  fi
  return 1
}

install_cask() {
  local token="$1" app="${2:-}"
  if cask_present "$token" "$app"; then
    skip "$token already installed"
    return
  fi
  log "installing $token"
  # some casks run an installer that needs a password; brew will prompt
  brew install --cask "$token"
  ok "$token installed"
}

# --- formulae ----------------------------------------------------------------
# second arg is an optional binary name: some tools get installed outside brew
# (uv's own installer drops it in ~/.local/bin), and reinstalling over that
# would leave two copies fighting over PATH.
install_formula() {
  local formula="$1" bin="${2:-}"
  if brew list --formula "$formula" >/dev/null 2>&1; then
    skip "$formula already installed"
    return
  fi
  if [ -n "$bin" ] && command -v "$bin" >/dev/null 2>&1; then
    skip "$bin already on PATH outside brew, leaving it"
    return
  fi
  log "installing $formula"
  brew install "$formula"
  ok "$formula installed"
}

# --- git clones --------------------------------------------------------------
# for things that install by being cloned into place (oh-my-zsh themes and
# plugins). shallow, since we never need their history.
clone_once() {
  local repo="$1" dest="$2" name="${3:-$(basename "$dest")}"
  if [ -d "$dest/.git" ]; then
    skip "$name already cloned"
    return
  fi
  if [ -e "$dest" ]; then
    warn "$dest exists but is not a git clone — leaving it alone"
    return
  fi
  log "cloning $name"
  mkdir -p "$(dirname "$dest")"
  git clone --depth=1 "$repo" "$dest" >/dev/null 2>&1 || die "could not clone $name"
  ok "$name cloned"
}

# --- symlinks ----------------------------------------------------------------
# the repo is the source of truth: every config lives here and is linked into
# place, so editing the live file edits the repo.
link() {
  local src="$REPO_ROOT/$1" dest="$2"
  [ -e "$src" ] || die "nothing to link at $src"
  mkdir -p "$(dirname "$dest")"

  if [ -L "$dest" ]; then
    if [ "$(readlink "$dest")" = "$src" ]; then
      skip "$dest already linked"
      return
    fi
    warn "$dest points at $(readlink "$dest"), relinking"
    rm "$dest"
  elif [ -e "$dest" ]; then
    # never silently destroy a real file the user may not have committed yet
    local backup="$dest.pre-dotfiles.$(date +%Y%m%d%H%M%S)"
    warn "$dest exists and is not a symlink, moving it to $backup"
    mv "$dest" "$backup"
  fi

  ln -s "$src" "$dest"
  ok "linked $dest -> $src"
}

# --- misc --------------------------------------------------------------------
app_running() { pgrep -xq "$1"; }
