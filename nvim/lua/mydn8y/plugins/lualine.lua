local lualine_setup, lualine = pcall(require, "lualine")
if not lualine_setup then
    return
end

local lualine_oceanicnext = require("lualine.themes.OceanicNext")

-- new colors for theme
local new_colors = {
  yellow = "#FFDA7B",
  black = "#000000",
}

lualine_oceanicnext.normal.a.fg = new_colors.black
lualine_oceanicnext.insert.a.fg = new_colors.black
lualine_oceanicnext.visual.a.fg = new_colors.black
lualine_oceanicnext.command = {
  a = {
    gui = "bold",
    bg = new_colors.yellow,
    fg = new_colors.black,
  },
}

-- configure lualine with modified theme
lualine.setup({
  options = {
    theme = lualine_oceanicnext,
  },
  sections = {
    lualine_c = {{'filename', path = 1}}
  }
})
