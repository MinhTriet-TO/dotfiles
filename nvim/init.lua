-- base config files
require("mydn8y.core.options")
require("mydn8y.core.keymaps")
require("mydn8y.core.colorscheme")
require("mydn8y.plugins-setup")
-- custom config files
require("mydn8y.plugins.autopairs")
require("mydn8y.plugins.comment")
require("mydn8y.plugins.nvim-tree")
require("mydn8y.plugins.lualine")
require("mydn8y.plugins.bufferline")
require("mydn8y.plugins.telescope")
require("mydn8y.plugins.treesitter")
require("mydn8y.plugins.nvim-cmp")
require("mydn8y.plugins.gitsigns")
require("mydn8y.plugins.alpha")
-- lsp focus
require("mydn8y.plugins.lsp.mason")
require("mydn8y.plugins.lsp.lspconfig")
