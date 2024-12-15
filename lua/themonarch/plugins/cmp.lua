return {
	"hrsh7th/nvim-cmp",
	enabled = false,
	version = false,
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		{
			"tzachar/cmp-tabnine",
			build = "./install.sh",
		},
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
	},
	config = function()
		local cmp = require("cmp")
		local ls = require("luasnip")
		local cmp_select = { behavior = cmp.SelectBehavior.Select }
		local max_items = 5

		local tabnine = require("cmp_tabnine.config")
		tabnine:setup({
			max_lines = 1000,
			max_num_results = 20,
			sort = true,
			run_on_every_keystroke = true,
			snippet_placeholder = "..",
			show_prediction_strength = false,
		})

		cmp.setup({
			completion = {
				completeopt = "menu,menuone,preview,noinsert",
			},

			window = {
				-- completion = cmp.config.window.bordered(),
				-- documentation = cmp.config.window.bordered(),
			},

			snippet = {
				expand = function(args)
					ls.lsp_expand(args.body)
					-- vim.snippet.expand(args.body)
				end,
			},

			mapping = {
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-y>"] = cmp.mapping(
					cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Insert,
						select = true,
					}),
					{ "i", "c" }
				),
			},

			sources = cmp.config.sources({
				{ name = "nvim_lsp", max_item_count = 5 },
				{ name = "luasnip" },
				{ name = "cmp_tabnine" },
				{ name = "buffer" },
				{ name = "path" },
				{ name = "lazydev", group_index = 0 },
			}),

			-- icons kinds
			formatting = {
				format = function(entry, vim_item)
					local icons = require("core.icons")
					if icons.kinds[vim_item.kind] then
						vim_item.kind = icons.kinds[vim_item.kind] .. vim_item.kind
					end

					-- Handle TabNine entries
					if entry.source.name == "cmp_tabnine" then
						vim_item.kind = "TabNine"
						if entry.completion_item.data and entry.completion_item.data.detail then
							vim_item.kind = vim_item.kind .. " " .. entry.completion_item.data.detail
						end
						if entry.completion_item.data and entry.completion_item.data.multiline then
							vim_item.kind = vim_item.kind .. " [ML]"
						end
					end

					local widths = {
						abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
						menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
					}

					for key, width in pairs(widths) do
						if vim_item[key] and vim.fn.strdisplaywidth(vim_item[key]) > width then
							vim_item[key] = vim.fn.strcharpart(vim_item[key], 0, width - 1) .. "..."
						end
					end

					return vim_item
				end,
			},
		})

		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer", max_item_count = max_items },
			},
		})

		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path", max_item_count = max_items },
			}, {
				{ name = "cmdline", max_item_count = max_items },
			}),
		})
		-- Set up an autocmd to prefetch Python files
		local au = vim.api.nvim_create_augroup("tabnine", { clear = true })
		vim.api.nvim_create_autocmd("BufRead", {
			group = au,
			pattern = "*.py",
			callback = function()
				require("cmp_tabnine"):prefetch(vim.fn.expand("%:p"))
			end,
		})
	end,
}
