-- =============================================================================
-- Bootstrap lazy.nvim and load all plugin specs
-- =============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "plugins" },        -- lua/plugins/*.lua
  { import = "custom.plugins" }, -- lua/custom/plugins/*.lua  (your extras)
}, {
  ui = {
    icons = {
      cmd     = "⌘", config = "🛠", event = "📅", ft     = "📂",
      init    = "⚙", keys   = "🗝", plugin = "🔌", runtime = "💻",
      source  = "📄", start  = "🚀", task   = "📌", lazy   = "💤",
    },
  },
  checker          = { enabled = true, notify = false },
  change_detection = { notify = false },
})
