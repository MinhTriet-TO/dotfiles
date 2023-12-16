-- import lspconfig plugin safely
local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
	return
end

-- import cmp-nvim-lsp plugin safely
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end

-- used to enable autocompletion (assign to every lsp server config)
local capabilities = cmp_nvim_lsp.default_capabilities()

local keymap = vim.keymap -- for conciseness

-- enable keybinds only for when lsp server available
local on_attach = function(client, bufnr)
	-- keybind options
	local opts = { noremap = true, silent = true, buffer = bufnr }
        -- definition is mostly preferred
        keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        -- check the definition of a keyword
        keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        -- check all references of a keyword
        -- keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        keymap.set("n", "gr", ":Telescope lsp_references<CR>", opts)
end

-- disable the general diagnostics
vim.diagnostic.disable()

-- configure pyright server
lspconfig["pyright"].setup({
    capabilities = capabilities,
	on_attach = on_attach,
})

-- configure pyright server
lspconfig["tsserver"].setup({
    capabilities = capabilities,
	on_attach = on_attach,
})
