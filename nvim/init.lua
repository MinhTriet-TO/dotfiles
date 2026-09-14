-- =============================================================================
-- Entry point
-- Leader must be set before lazy.nvim loads
-- =============================================================================
vim.g.mapleader      = ","
vim.g.maplocalleader = ","

-- Disable netrw (nvim-tree)
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1

-- Core
require("core.options")
require("core.keymaps")

-- Bootstrap lazy.nvim + load plugins
require("core.lazy")
