-- remap space as leader key
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

-- split panels inside vim
keymap.set("n", "<leader>sv", "<C-w>v") -- vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- resize equally panels
keymap.set("n", "<leader>sx", ":close<CR>") -- quit the current panel

-- map toggle code commenter with ", " as usual
keymap.set("n", "<leader><space>", ":CommentToggle<CR>")

-- budffer navigation
keymap.set("n", "<M-h>", ":bprevious<CR>")
keymap.set("n", "<M-l>", ":bnext<CR>")
keymap.set("n", "<C-n>", ":enew<CR>")
keymap.set("n", "<C-s>", ":w<CR>")
keymap.set("n", "<C-w>", ":Bdelete<CR>")
keymap.set("n", "<C-q>", ":q!<CR>")

-- remove search highlighting
keymap.set("n", "<leader>nh", ":nohl<CR>")

-- nvim-tree
keymap.set("n", "²", ":NvimTreeToggle<CR>")

-- list all buffers and quickly jump to one by number 
keymap.set("n", "<M-b>", ":buffers<CR>:buffer<space>")

-- find and replace (ctrl + h)
keymap.set("n", "<M-r>", "%s")

-- telescope
keymap.set("n", "<leader>ff", ":Telescope find_files<CR>") -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fs", ":Telescope live_grep<CR>") -- find string in current working directory as you type
keymap.set("n", "<leader>fc", ":Telescope grep_string<CR>") -- find string under cursor in current working directory
keymap.set("n", "<leader>fb", ":Telescope buffers<CR>") -- list open buffers in current neovim instance
keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>") -- list available help tags

-- 2. Insert
-- Press jk instead of escape to go back to normal mode
keymap.set("i", "lk", "<ESC>")

-- 3. Visual
-- jk stuff
keymap.set("v", "lk", "<ESC>")
-- map toggle code commenter with ", " as usual
keymap.set("v", "<leader><space>", ":CommentToggle<CR>")
-- do not delete into the register, aka true delete 
keymap.set("v", "d", '"_d')
-- Stay in indent mode
keymap.set("v", "<", "<gv", opts)

-- 4.Term
