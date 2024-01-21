-- import plugin alpha safely
local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
	return
end

-- load Dashboard config 
local dashboard = require("alpha.themes.dashboard")
local fortune = require("alpha.fortune") 

-- function to generate random colors
-- to find more colors, :highlight
math.randomseed(os.time())
local function pick_color()
    local colors = {
        --rainbow setup
        "Exception", --red
        "Operator", --orange
        "StorageClass", --yellow
        "String", --green
        "Function", --blue
        "Identifier", --indigo
        "Include", --violet
        "DevIconCrystal", --neutral
    }
    return colors[math.random(#colors)]
end

-- generate footer with a random wise word
local function footer()
    return fortune()
end

local logo = {
	[[                                                      ]],
	[[                                                      ]],
	[[                                                      ]],
	[[                                                      ]],
	[[                                                      ]],
    [[                                                      ]],
    [[                             __      ____             ]],
    [[        ____ ___  __  ______/ /___  ( __ )__  __      ]],
    [[       / __ `__ \/ / / / __  / __ \/ __  / / / /      ]],
    [[      / / / / / / /_/ / /_/ / / / / /_/ / /_/ /       ]],
    [[     /_/ /_/ /_/\__, /\__,_/_/ /_/\____/\__, /        ]],
    [[               /____/                  /____/         ]],
	[[                                                      ]],

}

-- header and footer config
color = pick_color()
dashboard.section.header.val = logo
dashboard.section.header.opts.hl = color
dashboard.section.footer.val = footer()
dashboard.section.footer.opts.hl = color

-- overwrite the button function in dashboard config in order to change button color
local if_nil = vim.F.if_nil
local leader = "SPC"
local function button(sc, txt, keybind, keybind_opts)
    local sc_ = sc:gsub("%s", ""):gsub(leader, "<leader>")

    color = pick_color()
    local opts = {
        position = "center",
        shortcut = sc,
        cursor = 3,
        width = 44,
        align_shortcut = "right",
        hl_shortcut = color,
        hl = color
    }
    if keybind then
        keybind_opts = if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
        opts.keymap = { "n", sc_, keybind, keybind_opts }
    end

    local function on_press()
        local key = vim.api.nvim_replace_termcodes(keybind or sc_ .. "<Ignore>", true, false, true)
        vim.api.nvim_feedkeys(key, "t", false)
    end

    return {
        type = "button",
        val = txt,
        on_press = on_press,
        opts = opts,
    }
end

dashboard.section.buttons.val = {
	button("f", "  File", ":Telescope find_files <CR>"),
	button("n", "  New", ":ene <BAR> startinsert <CR>"),
	button("r", "󰦖  Recent", ":Telescope oldfiles <CR>"),
	button("s", "  Text", ":Telescope live_grep <CR>"),
	button("c", "  Config", ":e ~/.config/nvim/init.lua<CR>"),
	button("q", "  Quit", ":qa<CR>"),
}

alpha.setup(dashboard.opts)
