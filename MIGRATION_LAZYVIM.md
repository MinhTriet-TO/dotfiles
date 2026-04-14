# Migration to lazyvim
This note is created in order to help memorizing the migration process from *neovim from scratch* to a *pre-configurated Lazyvim*.

**Why changing now?**
- Because it's not cool to always change/modify/update the config regularly.
- Because i messed with nvim long enough to change to something more stable
- Because the team that developped Lazyvim really focused on maintaning the product so that it's always stable to use

## Migration process by order
### custom plugin
From the lazyvim template, create, for each plugin, a lua file inside *./lua/plugin/* directory
- nvim-tmux-navigator
- colorscheme : using catppuccin for now in order to sync with tmux


### keymap
Look carefully each keymap from the current config, and compare to the keymap provided by Lazyvim.
Decide to whether go for the change, or stay with current config
<!-- -- 1. Normal -->
<!-- --- delete without copying content to the register -->
Keep the current config, it's just dump how delete functionality is associated wwith the paste default buffer.
<!-- -- split panels within nvim -->
Panel in vim = window in lazyvim. Don´t know why but it's just it.
A window could have one or more panels
We will use the Lazyvim keymap as it's more intuitive to use
<!-- -- map toggle code commenter with ", " as usual -->
We use *gc* to comment things now, as mini.comment is already installed.
<!-- -- buffer navigation -->
Current config to profit the left Alt key
<!-- -- quickfix buffer navigation -->
<!-- -- remove search highlighting -->
<!-- -- nvim-tree -->
<!-- -- find and replace (ctrl + h) -->
<!-- -- telescope -->
<!-- -- paste at the next line -->
<!-- -- navigation -->
<!-- -- Press lk instead of escape to go back to normal mode -->
<!-- -- When inside any sort of parentheses, quickly jump out out of it and continue writing -->
<!-- -- lk stuff -->
<!-- -- Stay in indent mode when bulk tab -->
All of the above are either non relevant, either being handled better within lazyvim.
<!-- -- do not delete into the register, aka true delete -->
We all want that instead of a dump delete that copy into the default " register
