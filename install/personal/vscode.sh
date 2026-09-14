#!/usr/bin/env bash
# vscode — install, then restore extensions and settings.
#
# spec asks for "theme, plugins, ...". the theme is not a separate thing to
# install: workbench.colorTheme in settings.json names it (Catppuccin Mocha)
# and the catppuccin.catppuccin-vsc extension provides it — so extensions +
# settings together are the theme.
#
# extensions are the slow part (28 of them, each a marketplace round trip), so
# this only installs the ones actually missing.

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

USER_DIR="$HOME/Library/Application Support/Code/User"
EXT_FILE="$REPO_ROOT/vscode/extensions.txt"

require_macos
ensure_brew

log "vscode"
install_cask visual-studio-code "Visual Studio Code.app"

# the `code` CLI is what makes the rest scriptable. the cask ships it inside
# the app bundle and symlinks it, but on a fresh install the symlink may not
# exist yet — fall back to the in-bundle path rather than giving up.
if ! command -v code >/dev/null 2>&1; then
  bundled="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
  if [ -x "$bundled" ]; then
    export PATH="$(dirname "$bundled"):$PATH"
    skip "using the code CLI from inside the app bundle"
  else
    die "the 'code' CLI isn't available — open vscode once and run 'Shell Command: Install code command in PATH'"
  fi
fi

# --- extensions --------------------------------------------------------------
if [ ! -f "$EXT_FILE" ]; then
  warn "no $EXT_FILE, skipping extensions"
else
  log "extensions"
  installed="$(code --list-extensions 2>/dev/null | tr '[:upper:]' '[:lower:]' | sort)"
  wanted=0
  added=0
  while read -r ext; do
    # tolerate blank lines and comments in the list
    [ -z "$ext" ] && continue
    case "$ext" in \#*) continue ;; esac
    wanted=$((wanted + 1))
    # marketplace ids are case insensitive, the CLI reports them lowercased
    if printf '%s\n' "$installed" | grep -qxF "$(printf '%s' "$ext" | tr '[:upper:]' '[:lower:]')"; then
      continue
    fi
    if code --install-extension "$ext" --force >/dev/null 2>&1; then
      ok "installed $ext"
      added=$((added + 1))
    else
      warn "could not install $ext"
    fi
  done < "$EXT_FILE"
  if [ "$added" -eq 0 ]; then
    skip "all $wanted extensions already present"
  else
    ok "$added of $wanted extensions installed"
  fi
fi

# --- settings ----------------------------------------------------------------
# not linked yet: `make link` will own settings.json and keybindings.json so
# that editing them in vscode edits the repo. until then, just report drift so
# the repo copy doesn't silently fall behind.
log "settings"
mkdir -p "$USER_DIR"
for f in settings.json keybindings.json; do
  repo_copy="$REPO_ROOT/vscode/$f"
  live="$USER_DIR/$f"
  [ -f "$repo_copy" ] || { warn "no repo copy of $f"; continue; }
  if [ ! -e "$live" ]; then
    cp "$repo_copy" "$live"
    ok "installed $f"
  elif [ -L "$live" ]; then
    skip "$f is a symlink (managed by make link)"
  elif diff -q "$repo_copy" "$live" >/dev/null 2>&1; then
    skip "$f matches the repo"
  else
    warn "$f differs from the repo copy — not overwriting"
    echo "     diff: diff '$repo_copy' '$live'"
  fi
done

ok "vscode done"
