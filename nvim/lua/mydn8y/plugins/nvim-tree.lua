local tree_setup, nvimtree = pcall(require, "nvim-tree")
if not tree_setup then
    return
end

-- recommended settings following the documentation
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

-- change color for arrows in tree to light blue
vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])

-- configure nvim-tree
nvimtree.setup({
  -- change folder arrow icons
  view = {
    adaptive_size = true,
    width = 25,
  },
  renderer = {
    root_folder_label = false,
    icons = {
        show = {
            folder_arrow = false,
        },

    },
    indent_markers = {
        enable = true,
        inline_arrows = true,
        icons = {
            corner = "└",
            edge = "│",
            item = "│",
            bottom = "─",
            none = " ",
        },
    },
  },
  -- disable window_picker for explorer to work well with window splits
  actions = {
    change_dir = {
        enable = false
    },
    open_file = {
      quit_on_open = true,
      window_picker = {
        enable = false,
      },
    },
  },
})  
