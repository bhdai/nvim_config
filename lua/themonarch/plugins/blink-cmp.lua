return {
	{
		"saghen/blink.cmp",
		version = "1.*",
		opts_extend = {
			"sources.completion.enabled_providers",
			"sources.compat",
			"sources.default",
		},
		dependencies = {
			"L3MON4D3/LuaSnip",
			{
				"saghen/blink.compat",
				opts = {},
				version = "*",
			},
			{
				"folke/lazydev.nvim",
				ft = "lua", -- only load on lua files
				opts = {
					library = {
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
			},
			{ "giuxtaposition/blink-cmp-copilot" },
		},
		event = "InsertEnter",

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			appearance = {
				use_nvim_cmp_as_default = false,
				nerd_font_variant = "mono",
			},

			-- highlight = {
			-- 	use_nvim_cmp_as_default = false,
			-- },
			completion = {
        list = { selection = { preselect = false, auto_insert = true } },
				accept = {
					auto_brackets = { enabled = true },
				},

				menu = {
					draw = {
						treesitter = { "lsp" },
					},
				},

				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
				ghost_text = {
					enabled = true,
				},
			},

			-- signature = {
			-- 	enabled = false,
			-- },

			keymap = {
				["<Tab>"] = {
					"snippet_forward",
					function()
						if vim.g.ai_accept then
							return vim.g.ai_accept()
						end
					end,
					"fallback",
				},
				["<S-Tab>"] = { "snippet_backward", "fallback" },
			},

      cmdline = {
        eanabled = true,
        completion = {
          menu = { auto_show = true},
          list = { selection = {preselect=false, auto_insert=true}},
        },
        keymap = {
          ["<Tab>"] = { "select_next", "fallback" },
          ["<S-Tab>"] = { "select_prev", "fallback" },
          ["<C-e>"] = { "cancel", "fallback" },
          ["<C-y>"] = { "select_and_accept" },
        }
      },

			sources = {
				default = { "lsp", "path", "snippets", "copilot", "buffer", "lazydev" },
				per_filetype = {
					sql = { "snippets", "dadbod", "buffer" },
				},
				providers = {
					-- dont show LuaLS require statements when lazydev has items
					lsp = { fallbacks = { "lazydev" } },
					lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
					copilot = {
						name = "copilot",
						module = "blink-cmp-copilot",
						-- kind = "Copilot",
						score_offset = 100,
						async = true,
					},
					dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
				},
			},
		},
	},
	{
		"saghen/blink.cmp",
		opts = function(_, opts)
			opts.appearance = opts.appearance or {}
			opts.appearance.kind_icons = vim.tbl_extend("keep", {
				Color = "██", -- Use block instead of icon for color items to make swatches more usable
			}, require("core.icons").kinds)
		end,
	},
}
