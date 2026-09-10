-- wezterm configuration.
--
-- deliberately minimal, and deliberately without key bindings: tmux owns
-- splits, windows and navigation. anything bound here would be a second layer
-- competing with the tmux prefix for the same muscle memory.
--
-- so this file is appearance only.

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- font -----------------------------------------------------------------------
-- MesloLGS is the narrow-line-spacing Meslo variant that powerlevel10k's own
-- font installer recommends, and the nerd font patch supplies p10k's glyphs.
-- installed by install/terminal/zsh.sh via the font-meslo-lg-nerd-font cask.
--
-- the plain family, not "... Nerd Font Mono": the Mono variant forces every
-- glyph into one cell, which is what makes p10k's powerline separators and
-- icons look pinched.
config.font = wezterm.font 'MesloLGS Nerd Font'
config.font_size = 13.0

-- colours --------------------------------------------------------------------
-- catppuccin mocha, to match the vscode theme and the slack sidebar. built into
-- wezterm, so there's no palette to paste or keep in sync. base is #1E1E2E,
-- the same value as the slack "system navigation" colour.
config.color_scheme = 'Catppuccin Mocha'

-- chrome ---------------------------------------------------------------------
-- no tab bar: tmux already draws a status line and window list, and two rows
-- of tabs is just lost vertical space.
config.enable_tab_bar = false

return config
