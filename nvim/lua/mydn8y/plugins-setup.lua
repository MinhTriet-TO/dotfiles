-- https://github.com/wbthomason/packer.nvim#bootstrapping for more details
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end
local packer_bootstrap = ensure_packer()

-- Autocommand that reloads neovim whenever you save this file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status, packer = pcall(require, "packer")
if not status then
	return
end

return packer.startup(function(use)
	-- plugins list - color your nvim world here
	use("wbthomason/packer.nvim") -- for sure, packer has to manage itself o.o

	use("nvim-lua/plenary.nvim") -- lua functions that many plugins use

	use("mhartington/oceanic-next") -- best colorscheme

	use("terrortylor/nvim-comment") -- commenter

	-- autoclosing
	use("windwp/nvim-autopairs")

	--autotag for html
	-- use("windwp/nvim-ts-autotag")

	-- tmux & split window navigation
	-- Ctrl hjkl for moving between vim split
	use("christoomey/vim-tmux-navigator")

	-- goodbye to NerdTree and say hello to nvim-tree
	use("nvim-tree/nvim-tree.lua")

	-- vs-code like icons
	use("nvim-tree/nvim-web-devicons")

	-- statusline
	use("nvim-lualine/lualine.nvim")

	-- bufferline (tabline)
	use("akinsho/bufferline.nvim")

	-- neater buffer/window/tab removal
	use("moll/vim-bbye")

	-- fuzzy finding w/ telescope
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- dependency for better sorting performance
	use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" }) -- fuzzy finder

	-- treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	})
	-- autocompletion
	use("hrsh7th/nvim-cmp") -- completion plugin
	use("hrsh7th/cmp-buffer") -- buffer completions
    use("hrsh7th/cmp-path") -- path completions
    use("hrsh7th/cmp-cmdline") -- cmdline completions
	use("saadparwaiz1/cmp_luasnip") -- snippet completions

	-- snippets
	use("L3MON4D3/LuaSnip") -- snippet engine
	use("rafamadriz/friendly-snippets") -- useful snippets

	-- git integration
	use("lewis6991/gitsigns.nvim") -- show line modifications on left hand side

	-- alpha dashboard
	use({ "goolord/alpha-nvim" })
    use({"BlakeJC94//alpha-nvim-fortune"})

	-- pre-commit hook
	use("ttibsi/pre-commit.nvim")

	--lsp
	-- managing & installing lsp servers, linters & formatters
	use("williamboman/mason.nvim") -- in charge of managing lsp servers, linters & formatters
	use("williamboman/mason-lspconfig.nvim") -- bridges gap b/w mason & lspconfig
	use("neovim/nvim-lspconfig") -- easily configure language servers
	use("hrsh7th/cmp-nvim-lsp") -- for autocompletion
    
	-- Automatically set up the configuration after cloning packer.nvim
	if packer_bootstrap then
		require("packer").sync()
	end
end)
