#!/usr/bin/env bash
# tmux — the multiplexer that owns splits, windows and navigation.
#
# ordering note: TPM reads the `@plugin` list out of ~/.tmux.conf, so the
# config has to be linked before plugins can be installed. `make run` does
# link before terminal, but running this script on its own may not have — so
# it checks and skips the plugin step rather than failing.
#
# plugins live in ~/.tmux/plugins and are NOT in the repo: they're upstream git
# clones that TPM manages, so committing them would just vendor other people's
# code with no way to update it.

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

TPM_DIR="$HOME/.tmux/plugins/tpm"

require_macos
ensure_brew

log "tmux"
install_formula tmux

# --- plugin manager ----------------------------------------------------------
clone_once https://github.com/tmux-plugins/tpm.git "$TPM_DIR" tpm

# --- plugins -----------------------------------------------------------------
if [ ! -e "$HOME/.tmux.conf" ]; then
  warn "no ~/.tmux.conf yet — run 'make link', then re-run this to get plugins"
elif [ ! -x "$TPM_DIR/bin/install_plugins" ]; then
  warn "tpm has no install_plugins script, install plugins with prefix+I instead"
else
  log "plugins"
  # count what's there first so the run can report whether it changed anything
  before="$(find "$HOME/.tmux/plugins" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')"
  "$TPM_DIR/bin/install_plugins" >/dev/null 2>&1 || warn "tpm reported a problem installing plugins"
  after="$(find "$HOME/.tmux/plugins" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')"
  if [ "$before" = "$after" ]; then
    skip "all $((after - 1)) plugins already installed"
  else
    ok "plugins installed ($((after - 1)) total)"
  fi

  # every plugin declared in the config should now exist on disk. a missing one
  # is silent otherwise — the status bar just renders wrong.
  missing=0
  while read -r plugin; do
    name="${plugin##*/}"
    [ -d "$HOME/.tmux/plugins/$name" ] || { warn "plugin not installed: $plugin"; missing=$((missing + 1)); }
  done < <(grep -oE "^set -g @plugin '[^']+'" "$HOME/.tmux.conf" | sed "s/.*'\(.*\)'/\1/")
  [ "$missing" -eq 0 ] && ok "every declared plugin is present"
fi

# --- config check ------------------------------------------------------------
# start a throwaway detached server against the config and see if tmux
# complains. this catches typos and unknown options, which otherwise only show
# up as an error flash the first time you attach.
if [ -e "$HOME/.tmux.conf" ]; then
  log "config check"
  if err="$(tmux -L dotfiles-check -f "$HOME/.tmux.conf" new-session -d -s check 2>&1)"; then
    [ -n "$err" ] && printf '%s\n' "$err" | head -5 | sed 's/^/     /'
    ok "config loads"
  else
    warn "tmux rejected the config:"
    printf '%s\n' "$err" | head -5 | sed 's/^/     /'
  fi
  # -L uses a private socket so this never touches a real session
  tmux -L dotfiles-check kill-server 2>/dev/null || true
fi

# --- reload a live server ----------------------------------------------------
# if tmux is already running, the new config isn't picked up until it's sourced
if tmux list-sessions >/dev/null 2>&1; then
  tmux source-file "$HOME/.tmux.conf" 2>/dev/null \
    && ok "reloaded the running server" \
    || warn "could not reload the running server, use prefix+C-r"
fi

ok "tmux done"
