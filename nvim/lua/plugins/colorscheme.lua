return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- load before everything else
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
      })
      vim.cmd("colorscheme catppuccin")
    end,
  },
}
