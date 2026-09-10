return {
  -- ── File tree ──────────────────────────────────────────────────────────────
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])
      require("nvim-tree").setup({
        view = { adaptive_size = true, width = 25 },
        renderer = {
          root_folder_label = false,
          icons = { show = { folder_arrow = false } },
          indent_markers = {
            enable        = true,
            inline_arrows = true,
            icons = { corner = "└", edge = "│", item = "│", bottom = "─", none = " " },
          },
        },
        actions = {
          change_dir = { enable = false },
          open_file = {
            quit_on_open = true,
            window_picker = { enable = false },
          },
        },
      })
    end,
  },

  -- ── Neater buffer deletion ─────────────────────────────────────────────────
  "moll/vim-bbye",

  -- ── Tmux / split navigation ────────────────────────────────────────────────
  -- Ctrl-h/j/k/l moves between nvim splits AND tmux panes seamlessly.
  -- Make sure your tmux.conf also has the matching bindings:
  --   bind -n C-h run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-h) || tmux select-pane -L"
  --   (and the same for C-j, C-k, C-l)
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft", "TmuxNavigateDown",
      "TmuxNavigateUp",   "TmuxNavigateRight",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<CR>",  desc = "Navigate left (nvim/tmux)" },
      { "<C-j>", "<cmd>TmuxNavigateDown<CR>",  desc = "Navigate down (nvim/tmux)" },
      { "<C-k>", "<cmd>TmuxNavigateUp<CR>",    desc = "Navigate up (nvim/tmux)" },
      { "<C-l>", "<cmd>TmuxNavigateRight<CR>", desc = "Navigate right (nvim/tmux)" },
    },
  },

  -- ── Maximize split ─────────────────────────────────────────────────────────
  "szw/vim-maximizer",

  -- ── Autopairs ──────────────────────────────────────────────────────────────
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,
        ts_config = {
          lua        = { "string" },
          javascript = { "template_string" },
          java       = false,
        },
      })
      -- Hook into nvim-cmp so pairs complete on confirm
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- ── Commenting ─────────────────────────────────────────────────────────────
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup({
        toggler  = { line = "<leader><space>" },
        opleader = { line = "<leader><space>" },
      })
    end,
  },

  -- ── Git signs ──────────────────────────────────────────────────────────────
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- ── Pre-commit helper ──────────────────────────────────────────────────────
  "ttibsi/pre-commit.nvim",
}
