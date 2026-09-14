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
-- 13 was too small to read comfortably. vscode is on its default 14, so this
-- sits a touch above it — nudge here rather than with cmd+/cmd-, which only
-- lasts for the session and would drift from the committed config.
config.font_size = 15.0

-- colours --------------------------------------------------------------------
-- catppuccin mocha, to match the vscode theme and the slack sidebar. built into
-- wezterm, so there's no palette to paste or keep in sync. base is #1E1E2E,
-- the same value as the slack "system navigation" colour.
config.color_scheme = 'Catppuccin Mocha'

-- cursor ---------------------------------------------------------------------
-- blinking beam. this is the terminal-level counterpart to the tmux line:
--   set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
-- which teaches tmux how to set and reset the cursor shape.
--
-- this one setting is also what restores the cursor after quitting nvim.
-- measured with a pty capture: nvim's last write is always a reset — ESC[0 q
-- on its own, or ESC[ q via tmux's Se — so the terminal default is the only
-- thing that decides the final shape. an autocmd inside nvim can't win,
-- because the reset comes after it. hence: set it here, once.
config.default_cursor_style = 'BlinkingBar'

-- blink speed. the default 800ms felt sluggish; 400 is a normal terminal blink.
config.cursor_blink_rate = 400

-- and this is the setting that actually makes it feel snappy: by default
-- wezterm *fades* the cursor in and out with easing, which reads as slow even
-- at a short rate. 'Constant' gives a hard on/off blink instead.
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'

-- chrome ---------------------------------------------------------------------
-- no tab bar: tmux already draws a status line and window list, and two rows
-- of tabs is just lost vertical space.
config.enable_tab_bar = false

return config
