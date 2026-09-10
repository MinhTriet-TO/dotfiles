#!/usr/bin/env bash
# symlink configs out of the repo into the places the tools read them.
#
# this is what makes the repo the source of truth rather than a copy: after
# linking, editing ~/.gitconfig *is* editing the repo, so the two can never
# drift apart. the heavy lifting (backups, idempotency, parent dirs) is in
# link() in lib/common.sh.
#
# deliberately only git for now. .zshrc, .tmux.conf and nvim get added here
# once the terminal setup is in place — linking the repo's 175-line .zshrc onto
# a machine that lacks pyenv/nvm/asdf/lsd would break the shell on startup.

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/lib" && pwd)/common.sh"

require_macos

log "linking configs"

# --- git ---------------------------------------------------------------------
link "git/gitignore.global" "$HOME/.gitignore"

# identity is NOT in the repo's .gitconfig — it lives in ~/.gitconfig.local,
# which the committed .gitconfig includes at the end. linking before that file
# exists would leave the machine with no user.email at all, so skip it rather
# than half-configure git. skipped and not fatal, so `make run` still finishes.
if [ -f "$HOME/.gitconfig.local" ]; then
  link ".gitconfig" "$HOME/.gitconfig"
else
  warn "skipping .gitconfig — ~/.gitconfig.local is missing"
  echo "     run 'make github' first; linking now would drop your git identity"
fi

# --- zsh ---------------------------------------------------------------------
# .zshrc sources ~/.zsh_secrets, and the real values live in the repo copy
# (gitignored) so that this link is the only thing putting them in place.
# seeded by install/terminal/zsh.sh.
if [ -f "$REPO_ROOT/.zsh_secrets" ]; then
  link ".zsh_secrets" "$HOME/.zsh_secrets"
else
  warn "no .zsh_secrets in the repo yet — run 'make terminal' first"
fi

link ".zshrc" "$HOME/.zshrc"

# the prompt config, generated once by `p10k configure`. .zshrc sources it only
# if present, so this link is what carries the prompt to a new machine.
link ".p10k.zsh" "$HOME/.p10k.zsh"

# --- wezterm -----------------------------------------------------------------
# wezterm also reads ~/.config/wezterm/wezterm.lua, but ~/.wezterm.lua keeps it
# alongside the other root dotfiles in this repo.
link ".wezterm.lua" "$HOME/.wezterm.lua"

# --- pending -----------------------------------------------------------------
# link ".tmux.conf" "$HOME/.tmux.conf"
# link "nvim"       "$HOME/.config/nvim"

echo
ok "linked"
skip "still pending: .tmux.conf, nvim (see the terminal setup work)"
