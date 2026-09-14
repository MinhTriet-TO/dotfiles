-- =============================================================================
-- Keymaps
-- =============================================================================
local km = vim.keymap.set

-- Delete without yanking into default register
km("n", "x",  '"_x')
km("n", "dw", '"_dw')
km("n", "dd", '"_dd')
km("n", "d$", '"_d$')
km("v", "d",  '"_d')

-- Window splits
km("n", "<leader>sh", "<C-w>v")      -- vertical split
km("n", "<leader>sv", "<C-w>s")      -- horizontal split
km("n", "<leader>se", "<C-w>=")      -- equalize splits
km("n", "<leader>sx", ":close<CR>")  -- close split
km("n", "<leader>sz", ":MaximizerToggle<CR>")

-- Window / tmux-pane navigation: C-h/j/k/l is handled by vim-tmux-navigator
-- (see lua/plugins/editor.lua)

-- Buffer navigation
km("n", "<M-h>",   ":bprevious<CR>")
km("n", "<M-l>",   ":bnext<CR>")
km("n", "<C-n>",   ":enew<CR>")
km("n", "<C-q>",   ":Bdelete<CR>")
km("n", "<C-M-w>", ":Bdelete!<CR>")

-- Quickfix
km("n", "<leader>gc", ":ccl<CR>")   -- close
km("n", "<leader>gq", ":cope<CR>")  -- reopen
km("n", "<leader>gn", ":cn<CR>")    -- next
km("n", "<leader>gp", ":cp<CR>")    -- previous

-- Search
km("n", "<leader>nh", ":nohl<CR>")

-- File tree
km("n", "<leader>b", ":NvimTreeToggle<CR>")

-- Find & replace
km("n", "<M-r>", ":%s/")

-- Telescope
km("n", "<leader>ff", ":Telescope find_files<CR>")   -- find files
km("n", "<leader>fs", ":Telescope live_grep<CR>")    -- live grep
km("n", "<leader>fc", ":Telescope grep_string<CR>")  -- grep word under cursor
km("n", "<leader>fb", ":Telescope buffers<CR>")      -- open buffers
km("n", "<leader>fh", ":Telescope oldfiles<CR>")     -- recent files

-- Paste on next line
km("n", "<leader>p", ":pu<CR>")

-- Line navigation
km("n", "<C-a>", "0")       -- start of line
km("n", "<C-e>", "$")       -- end of line
km("n", "<M-j>", "<C-f>")   -- page down
km("n", "<M-k>", "<C-b>")   -- page up
km("n", "<M-u>", "<C-u>")   -- half page up
km("n", "<M-d>", "<C-d>")   -- half page down

-- Visual mode
km("v", "lk", "<ESC>")
km("v", "<",  "<gv")   -- stay in indent mode
km("v", ">",  ">gv")
