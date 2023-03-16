-- import plugin alpha safely
local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
	return
end

local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
	[[                                                       ]],
	[[                                                       ]],
	[[                                                       ]],
	[[                                                       ]],
	[[                                                       ]],
	[[                                                       ]],
	[[███╗   ███╗██╗   ██╗██████╗ ███╗   ██╗ █████╗ ██╗   ██╗]],
	[[████╗ ████║╚██╗ ██╔╝██╔══██╗████╗  ██║██╔══██╗╚██╗ ██╔╝]],
	[[██╔████╔██║ ╚████╔╝ ██║  ██║██╔██╗ ██║╚█████╔╝ ╚████╔╝ ]],
	[[██║╚██╔╝██║  ╚██╔╝  ██║  ██║██║╚██╗██║██╔══██╗  ╚██╔╝  ]],
	[[██║ ╚═╝ ██║   ██║   ██████╔╝██║ ╚████║╚█████╔╝   ██║   ]],
	[[╚═╝     ╚═╝   ╚═╝   ╚═════╝ ╚═╝  ╚═══╝ ╚════╝    ╚═╝   ]],
	[[                                                       ]],
	[[                                                       ]],
}

dashboard.section.buttons.val = {
	dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
	dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("h", "  Recently used files", ":Telescope oldfiles <CR>"),
	dashboard.button("s", "  Find text", ":Telescope live_grep <CR>"),
	dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua<CR>"),
	dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
}

local function footer()
	return "Yerterday is history. Tomorrow is mistery. Today is a gift. That's why it's called present"
end

dashboard.section.footer.val = footer()

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true
alpha.setup(dashboard.opts)
