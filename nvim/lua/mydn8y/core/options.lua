-- line number
vim.opt.number = true -- set numbered lines
vim.opt.relativenumber = false -- deactivate set relative numbered lines
vim.opt.numberwidth = 2 -- set number column width to 2 {default 4}

-- things related to tab
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.shiftwidth = 4 -- the number of spaces inserted for each indentation
vim.opt.tabstop = 4 -- insert 2 spaces for a tab
vim.opt.autoindent = true -- automatically indentation
vim.opt.showtabline = 2 -- always show tabline

-- line wrapping
vim.opt.wrap = true -- display lines as one long line

-- search settings
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- if searched string contains uppercase, override ignorecase

-- backspace
vim.opt.backspace = "indent,eol,start"

-- clipboard
vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard

-- split windows
vim.opt.splitbelow = true -- force all horizontal splits to go below current window
vim.opt.splitright = true -- force all vertical splits to go to the right of current window
-- UX
vim.opt.termguicolors = true -- set term gui colors (most terminals support this)
vim.opt.iskeyword:append("-") -- consider the - as part of the word
vim.opt.updatetime = 300 -- change default completion which was 4s
vim.opt.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
vim.opt.showmode = false -- with lualine installed, remove the default mode indicator
vim.opt.hidden = true

vim.opt.fillchars:append({ eob = " " })

-- because accidentally touching the pad while typing is very painful
vim.opt.mouse = ""
