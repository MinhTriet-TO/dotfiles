local lualine_setup, lualine = pcall(require, "lualine")
if not lualine_setup then
    return
end

-- new colors for theme
local new_colors = {
  yellow = "#FFDA7B",
  black = "#000000",
}

-- configure lualine with modified theme
lualine.setup({
  options = {
    theme = "auto",
    disabled_filetypes = {
      statusline = { "alpha" } 
    },
  },
  sections = {
    lualine_c = {{'filename', path = 1}}
  }
})
