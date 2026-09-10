#!/usr/bin/env bash
# neovim — small hand-owned config on lazy.nvim (migrated off packer).
#
# lazy.nvim is the plugin manager only, not the LazyVim distro: every spec in
# nvim/lua/plugins is ours. that's a deliberate choice — no LSP, no treesitter,
# in exchange for staying minimal.
#
# ordering note, same as tmux: lazy.nvim reads the plugin specs from
# ~/.config/nvim, so the config has to be linked before plugins can sync.
# `make run` links first; running this script alone may not have, so it checks.
#
# plugins are NOT in the repo — lazy.nvim clones them into
# ~/.local/share/nvim/lazy. What *is* committed is nvim/lazy-lock.json, which
# pins every plugin to an exact commit, so `lazy! restore` reproduces the same
# versions on a new machine instead of whatever upstream is that day.

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

NVIM_CONFIG="$HOME/.config/nvim"

require_macos
ensure_brew

log "neovim"
install_formula neovim nvim

# telescope's live_grep shells out to ripgrep, and fd is its faster file
# finder. without rg, <leader>fs silently returns nothing.
install_formula ripgrep rg
install_formula fd

# telescope-fzf-native compiles a C extension via `make` on install, which
# needs the command line tools. they're a prerequisite of the whole bootstrap,
# so this is a check rather than an install.
if ! xcode-select -p >/dev/null 2>&1; then
  warn "xcode command line tools missing — telescope-fzf-native won't build"
fi

# --- plugins -----------------------------------------------------------------
if [ ! -e "$NVIM_CONFIG" ]; then
  warn "no ~/.config/nvim yet — run 'make link', then re-run this to sync plugins"
else
  log "plugins"
  # restore, not sync: restore installs the exact commits from lazy-lock.json.
  # `sync` would update to upstream HEAD and rewrite the lockfile, which is the
  # opposite of what a reproducible bootstrap wants.
  if nvim --headless "+Lazy! restore" +qa >/dev/null 2>&1; then
    ok "plugins restored from lazy-lock.json"
  else
    warn "lazy restore reported a problem — open nvim and check :Lazy"
  fi

  # count what actually landed, so a silent failure doesn't look like success
  plugin_dir="$HOME/.local/share/nvim/lazy"
  if [ -d "$plugin_dir" ]; then
    installed="$(find "$plugin_dir" -maxdepth 1 -mindepth 1 -type d | wc -l | tr -d ' ')"
    pinned="$(grep -c '": {' "$REPO_ROOT/nvim/lazy-lock.json" 2>/dev/null || echo 0)"
    if [ "$installed" -ge "$pinned" ]; then
      ok "$installed plugins installed ($pinned pinned in the lockfile)"
    else
      warn "only $installed of $pinned plugins installed — check :Lazy"
    fi
  fi
fi

# --- health ------------------------------------------------------------------
# a config error only shows as a flash of red on first launch, so surface it
# here instead. this starts nvim headless and reports anything on stderr.
log "startup check"
if err="$(nvim --headless +qa 2>&1)"; then
  if [ -n "$err" ]; then
    warn "nvim printed warnings on startup:"
    printf '%s\n' "$err" | head -5 | sed 's/^/     /'
  else
    ok "nvim starts clean"
  fi
else
  warn "nvim failed to start:"
  printf '%s\n' "$err" | head -5 | sed 's/^/     /'
fi

ok "neovim done"
