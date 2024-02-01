-- remap comma as leader key
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- shorten function name
local keymap = vim.keymap
-- Function syntax: keymap.set(mode, replaced_key, key_to_replace)

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- 1. Normal
--- delete without copying content to the register
keymap.set("n", "x", '"_x')
keymap.set("n", "dw", '"_dw')
keymap.set("n", "dd", '"_dd')
keymap.set("n", "d$", '"_d$')

-- split panels within nvim
keymap.set("n", "<leader>sh", "<C-w>v") -- vertically
keymap.set("n", "<leader>sv", "<C-w>s") -- horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- resize equally panels
keymap.set("n", "<leader>sx", ":close<CR>") -- close the current panel
keymap.set("n", "<leader>sz", ":MaximizerToggle<CR>") -- quit the current panel

-- map toggle code commenter with ", " as usual
-- keymap.set("n", "<leader><space>", ":CommentToggle<CR>")
-- keymap.set("n", "<leader><space>", "gcc")

-- buffer navigation
keymap.set("n", "<M-h>", ":bprevious<CR>")
keymap.set("n", "<M-l>", ":bnext<CR>")
keymap.set("n", "<C-n>", ":enew<CR>")
keymap.set("n", "<C-w>", ":Bdelete<CR>")
keymap.set("n", "<C-M-w>", ":Bdelete!<CR>")

-- quickfix buffer navigation
keymap.set("n", "<leader>gc", ":ccl<CR>" ) --close it
keymap.set("n", "<leader>gq", ":cope<CR>" ) --reopen it
keymap.set("n", "<leader>gn", ":cn<CR>" ) --next reference
keymap.set("n", "<leader>gp", ":cp<CR>" ) --previous reference

-- remove search highlighting
keymap.set("n", "<leader>nh", ":nohl<CR>")

-- nvim-tree
keymap.set("n", "`", ":NvimTreeToggle<CR>")

-- find and replace (ctrl + h)
keymap.set("n", "<M-r>", ":%s/")

-- telescope
keymap.set("n", "<leader>ff", ":Telescope find_files<CR>") -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fs", ":Telescope live_grep<CR>") -- find string in current working directory as you type
keymap.set("n", "<leader>fc", ":Telescope grep_string<CR>") -- find string under cursor in current working directory
keymap.set("n", "<leader>fb", ":Telescope buffers<CR>") -- list open buffers in current neovim instance
keymap.set("n", "<leader>fh", ":Telescope oldfiles<CR>") -- list available help tags

-- paste at the next line
keymap.set("n", "<leader>p", ":pu<CR>")

-- navigation
keymap.set("n", "<C-a>", "0") -- start typing at the beginning of the line
keymap.set("n", "<C-e>", "$") -- start typing at the end of the line
keymap.set("n", "<M-j>", "<C-f>") -- move foward full page
keymap.set("n", "<M-k>", "<C-b>") -- move backward full page
keymap.set("n", "<M-u>", "<C-u>") -- move foward
keymap.set("n", "<M-d>", "<C-d>") -- move foward

-- 2. Insert
-- Press lk instead of escape to go back to normal mode
keymap.set("i", "lk", "<ESC>")
-- When inside any sort of parentheses, quickly jump out out of it and continue writing
keymap.set("i", "<M-n>", "<ESC>A")

-- 3. Visual
-- lk stuff
keymap.set("v", "lk", "<ESC>")
-- map toggle code commenter with ", " as usual
-- keymap.set("v", "<leader><space>", ":CommentToggle<CR>")
-- do not delete into the register, aka true delete
keymap.set("v", "d", '"_d')
-- Stay in indent mode
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- Permanently block arrow key to force learning hjkl
-- keymap.set("", "<up>", "<nop>", { noremap = true })
-- keymap.set("", "<down>", "<nop>", { noremap = true })
-- keymap.set("i", "<up>", "<nop>", { noremap = true })
-- keymap.set("i", "<down>", "<nop>", { noremap = true })
-- keymap.set("", "<left>", "<nop>", { noremap = true })
-- keymap.set("i", "<left>", "<nop>", { noremap = true })
-- keymap.set("", "<right>", "<nop>", { noremap = true })
-- keymap.set("i", "<right>", "<nop>", { noremap = true })

-- 4.Term
