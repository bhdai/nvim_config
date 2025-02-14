return {
	{
		"saghen/blink.cmp",
		enabled = true,
		build = "cargo build --release",
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
					enabled = vim.g.ai_cmp,
				},
			},

			-- signature = {
			-- 	enabled = false,
			-- },

			sources = {
				default = { "lsp", "path", "snippets", "buffer", "lazydev" },
				-- cmdline = {},
				providers = {
					-- dont show LuaLS require statements when lazydev has items
					lsp = { fallbacks = { "lazydev" } },
					lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
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
