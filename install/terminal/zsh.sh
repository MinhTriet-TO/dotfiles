#!/usr/bin/env bash
# zsh — oh-my-zsh, powerlevel10k, and everything .zshrc expects to find.
#
# scope: the tools .zshrc actually references. mise manages runtimes now, so
# asdf and nvm are both out of scope (and no longer referenced by .zshrc).
#
# aws_configure is hand-rolled and stays that way — the function and ~/.aws are
# assumed to exist rather than being set up here.
#
# ordering matters in one place: oh-my-zsh must be installed before the theme
# and plugin clones, because they go into its custom/ directory.

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

OMZ="$HOME/.oh-my-zsh"

require_macos
ensure_brew

# --- tools .zshrc calls ------------------------------------------------------
log "zsh tooling"
install_formula lsd                  # alias ls="lsd --group-dirs first --oneline"
install_formula neovim nvim          # alias vim=nvim, MANPAGER, PSQL_EDITOR
install_formula fzf                  # aws_configure picks the profile with it
install_formula mise                 # eval "$(mise activate zsh)"
install_formula uv uv                # python tooling

# powerlevel10k draws its prompt with nerd font glyphs, and vscode's
# settings.json asks for the same family — without it the prompt is mojibake.
install_cask font-meslo-lg-nerd-font

# --- oh-my-zsh ---------------------------------------------------------------
log "oh-my-zsh"
if [ -d "$OMZ" ]; then
  skip "already installed"
else
  # KEEP_ZSHRC=yes is the important one: by default the installer renames the
  # existing .zshrc to .zshrc.pre-oh-my-zsh and drops in its own template,
  # which would clobber the symlink to the repo.
  # RUNZSH=no stops it exec'ing a new shell and hanging the script.
  # CHSH=no because macOS already defaults to zsh.
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    >/dev/null 2>&1 || die "oh-my-zsh install failed"
  ok "installed"
fi

# ZSH_CUSTOM is where themes and plugins go; .zshrc never overrides it
ZSH_CUSTOM="${ZSH_CUSTOM:-$OMZ/custom}"

# --- theme and plugins ------------------------------------------------------
log "theme and plugins"
clone_once https://github.com/romkatv/powerlevel10k.git \
  "$ZSH_CUSTOM/themes/powerlevel10k" powerlevel10k
clone_once https://github.com/zsh-users/zsh-autosuggestions.git \
  "$ZSH_CUSTOM/plugins/zsh-autosuggestions" zsh-autosuggestions

# --- default shell ----------------------------------------------------------
# modern macOS already ships zsh as the login shell, so this is a no-op there;
# it only matters on a machine someone had switched to bash.
current_shell="$(dscl . -read "/Users/$USER" UserShell 2>/dev/null | awk '{print $2}')"
case "$current_shell" in
  */zsh) skip "login shell is already $current_shell" ;;
  *)     warn "login shell is $current_shell — change it with: chsh -s /bin/zsh" ;;
esac

# --- secrets file -----------------------------------------------------------
# lives in the repo (gitignored) so `make link` can symlink it to ~, keeping
# the repo the single place configs live. seeded from the template so a fresh
# machine has the right shape to fill in rather than a missing file.
log "secrets"
if [ -f "$REPO_ROOT/.zsh_secrets" ]; then
  skip ".zsh_secrets already exists"
else
  cp "$REPO_ROOT/.zsh_secrets.example" "$REPO_ROOT/.zsh_secrets"
  chmod 600 "$REPO_ROOT/.zsh_secrets"
  ok "seeded .zsh_secrets from the template"
  warn "fill in the tokens and SLACK_USERID — it's gitignored, so it stays local"
fi

# --- p10k prompt config -----------------------------------------------------
# the committed .p10k.zsh came out of `p10k configure`; `make link` puts it in
# place. re-running the wizard rewrites ~/.p10k.zsh, which — being a symlink —
# means it rewrites the repo copy, so the prompt stays version controlled.
if [ -f "$REPO_ROOT/.p10k.zsh" ]; then
  skip "prompt config in the repo, linked by 'make link'"
else
  warn "no .p10k.zsh in the repo — run 'p10k configure', then copy it here"
fi

echo
ok "zsh done — open a new shell to pick it up"
skip "runtimes are mise's job: asdf and nvm are intentionally not installed"
