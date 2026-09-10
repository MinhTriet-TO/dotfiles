return {
  -- ── Icons ──────────────────────────────────────────────────────────────────
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({
        strict = true,
        override_by_extension = {
          ["toml"]   = { icon = "",  color = "#3273ad", name = "Toml" },
          ["duckdb"] = { icon = "",  color = "#dddd08", name = "Duckdb" },
          ["wal"]    = { icon = "",  color = "#dddd08", name = "DuckdbWal" },
        },
      })
    end,
  },

  -- ── Statusline ─────────────────────────────────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          disabled_filetypes = { statusline = { "alpha" } },
        },
        sections = {
          lualine_c = { { "filename", path = 1 } },
        },
      })
    end,
  },

  -- ── Bufferline ─────────────────────────────────────────────────────────────
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          numbers             = "none",
          close_command       = "Bdelete! %d",
          right_mouse_command = "Bdelete! %d",
          left_mouse_command  = "buffer %d",
          indicator_icon      = "▎",
          buffer_close_icon   = "",
          modified_icon       = "●",
          close_icon          = "",
          left_trunc_marker   = "",
          right_trunc_marker  = "",
          max_name_length     = 30,
          max_prefix_length   = 30,
          tab_size            = 21,
          diagnostics         = false,
          diagnostics_update_in_insert = false,
          offsets = {
            {
              filetype   = "NvimTree",
              text       = "nvim-󱁕",
              text_align = "center",
              separator  = true,
              padding    = 0.9,
            },
          },
          show_buffer_icons       = true,
          show_buffer_close_icons = true,
          show_close_icon         = true,
          show_tab_indicators     = true,
          persist_buffer_sort     = true,
          separator_style         = "thin",
          enforce_regular_tabs    = true,
          always_show_bufferline  = false,
        },
      })
    end,
  },

  -- ── Dashboard ──────────────────────────────────────────────────────────────
  {
    "goolord/alpha-nvim",
    config = function()
      local alpha     = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      local fortune   = require("alpha.fortune")

      math.randomseed(os.time())
      local function pick_color()
        local colors = {
          "Exception", "Operator", "StorageClass", "String",
          "Function", "Identifier", "Include", "DevIconCrystal",
        }
        return colors[math.random(#colors)]
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
        [[------------------------------------------------------]],
        [[                                                      ]],
      }

      local color = pick_color()
      dashboard.section.header.val      = logo
      dashboard.section.header.opts.hl  = color
      dashboard.section.footer.val      = fortune()
      dashboard.section.footer.opts.hl  = color

      local if_nil = vim.F.if_nil
      local function button(sc, txt, keybind, keybind_opts)
        local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")
        local btn_color = pick_color()
        local opts = {
          position       = "center",
          shortcut       = sc,
          cursor         = 3,
          width          = 44,
          align_shortcut = "right",
          hl_shortcut    = btn_color,
          hl             = btn_color,
        }
        if keybind then
          keybind_opts = if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
          opts.keymap  = { "n", sc_, keybind, keybind_opts }
        end
        local function on_press()
          local key = vim.api.nvim_replace_termcodes(keybind or sc_ .. "<Ignore>", true, false, true)
          vim.api.nvim_feedkeys(key, "t", false)
        end
        return { type = "button", val = txt, on_press = on_press, opts = opts }
      end

      dashboard.section.buttons.val = {
        button("f", "  File",   ":Telescope find_files <CR>"),
        button("n", "  New",    ":ene <BAR> startinsert <CR>"),
        button("r", "  Recent", ":Telescope oldfiles <CR>"),
        button("s", "  Text",   ":Telescope live_grep <CR>"),
        button("c", "  Config", ":e ~/.config/nvim/init.lua<CR>"),
        button("q", "  Quit",   ":qa<CR>"),
      }

      alpha.setup(dashboard.opts)
    end,
  },
}
