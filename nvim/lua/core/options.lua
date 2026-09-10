-- =============================================================================
-- Options
-- =============================================================================
local opt = vim.opt

-- Line numbers
opt.number         = true
opt.relativenumber = false
opt.numberwidth    = 2

-- Tabs / indentation
opt.expandtab  = true
opt.shiftwidth = 2
opt.tabstop    = 2
opt.showtabline = 2

-- Wrapping
opt.wrap = true

-- Search
opt.ignorecase = true
opt.smartcase  = true

-- Backspace
opt.backspace = "indent,eol,start"

-- Clipboard
opt.clipboard = "unnamedplus"

-- Splits
opt.splitbelow = true
opt.splitright = true

-- UX
opt.termguicolors = true
opt.iskeyword:append("-")
opt.updatetime  = 300
opt.signcolumn  = "yes"
opt.showmode    = false      -- lualine handles this
opt.hidden      = true
opt.fillchars:append({ eob = " " })
opt.mouse       = ""         -- disable accidental touchpad clicks
opt.backup      = false
opt.writebackup = false
