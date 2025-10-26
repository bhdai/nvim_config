return {
	-- Core blink.cmp configuration
	{
		"saghen/blink.cmp",
		version = "1.*",
		opts_extend = {
			"sources.completion.enabled_providers",
			"sources.compat",
			"sources.default",
		},
		dependencies = {
			"rafamadriz/friendly-snippets",
			{
				"saghen/blink.compat",
				opts = {},
				version = "*",
			},
			{ "giuxtaposition/blink-cmp-copilot" },
		},
		event = { "InsertEnter", "CmdlineEnter" },

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			appearance = {
				use_nvim_cmp_as_default = false,
				nerd_font_variant = "mono",
				kind_icons = vim.tbl_extend("keep", {
					Color = "██", -- Use block instead of icon for color items to make swatches more usable
				}, require("core.icons").kinds),
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

			snippets = {
				preset = "luasnip",
			},

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
				enabled = true,
				completion = {
					menu = {
						auto_show = function(ctx)
							return vim.fn.getcmdtype() == ":"
						end,
					},
					ghost_text = { enabled = true },
					list = { selection = { preselect = false } },
				},
				keymap = { preset = "cmdline" },
			},

			sources = {
				default = { "lsp", "path", "snippets", "copilot", "buffer", "lazydev" },
				providers = {
					-- dont show LuaLS require statements when lazydev has items
					lsp = { fallbacks = { "lazydev" } },
					copilot = {
						name = "copilot",
						module = "blink-cmp-copilot",
						-- kind = "Copilot",
						score_offset = 100,
						async = true,
					},
				},
			},
		},
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

	-- add lazydev source to blink.cmp for Lua files
	{
		"saghen/blink.cmp",
		opts = {
			sources = {
				per_filetype = {
					lua = { inherit_defaults = true, "lazydev" },
				},
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100, -- show at a higher priority than lsp
					},
				},
			},
		},
	},
}
