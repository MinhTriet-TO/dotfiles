#!/usr/bin/env bash
# wezterm — terminal emulator.
#
# the config itself is .wezterm.lua at the repo root, put in place by
# `make link`. this script only installs the app and the font it asks for.
#
# the font cask is also installed by zsh.sh (powerlevel10k needs the same
# glyphs). install_cask is idempotent, so requesting it in both places costs a
# no-op and keeps each script runnable on its own.

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

require_macos
ensure_brew

log "wezterm"
install_cask wezterm "WezTerm.app"
install_cask font-meslo-lg-nerd-font

# --- config check ------------------------------------------------------------
# wezterm validates its own config, including whether a named color_scheme
# exists, so let it check ours rather than finding out at first launch. the CLI
# lives inside the bundle and isn't on PATH by default.
WEZTERM_BIN="/Applications/WezTerm.app/Contents/MacOS/wezterm"
if [ ! -x "$WEZTERM_BIN" ]; then
  skip "wezterm CLI not found in the bundle, skipping the config check"
elif [ ! -f "$REPO_ROOT/.wezterm.lua" ]; then
  warn "no .wezterm.lua in the repo"
else
  # ls-fonts is just a cheap excuse to make wezterm parse the config
  if err="$("$WEZTERM_BIN" --config-file "$REPO_ROOT/.wezterm.lua" ls-fonts 2>&1 >/dev/null)"; then
    if printf '%s' "$err" | grep -qi 'error'; then
      warn "wezterm reported a config problem:"
      printf '%s\n' "$err" | grep -i 'error' | head -3 | sed 's/^/     /'
    else
      ok "config is valid"
    fi
  else
    warn "wezterm could not parse .wezterm.lua"
    printf '%s\n' "$err" | head -3 | sed 's/^/     /'
  fi
fi

ok "wezterm done — 'make link' puts the config in place"
