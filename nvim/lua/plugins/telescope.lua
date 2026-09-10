return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<M-k>"] = actions.move_selection_previous,
              ["<M-j>"] = actions.move_selection_next,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<ESC>"] = actions.close,
            },
          },
        },
      })
      require("telescope").load_extension("fzf")
    end,
  },
}
