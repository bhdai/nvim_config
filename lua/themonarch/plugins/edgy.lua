return {
	"folke/edgy.nvim",
	event = "VeryLazy",
	keys = {
		{
			"<leader>ue",
			function()
				require("edgy").toggle()
			end,
			desc = "Edgy Toggle",
		},
    -- stylua: ignore
    { "<leader>uE", function() require("edgy").select() end, desc = "Edgy Select Window" },
	},
	opts = function()
		local utils = require("core.utils.general")
		local opts = {
			bottom = {
				{
					ft = "noice",
					size = { height = 0.4 },
					filter = function(buf, win)
						return vim.api.nvim_win_get_config(win).relative == ""
					end,
				},
				{
					ft = "lazyterm",
					title = "LazyTerm",
					size = { height = 0.4 },
					filter = function(buf)
						return not vim.b[buf].lazyterm_cmd
					end,
				},
				"Trouble",
				{ ft = "qf", title = "QuickFix" },
				{
					ft = "help",
					size = { height = 20 },
					-- don't open help files in edgy that we're editing
					filter = function(buf)
						return vim.bo[buf].buftype == "help"
					end,
				},
				{ title = "Spectre", ft = "spectre_panel", size = { height = 0.4 } },
				{ title = "Neotest Output", ft = "neotest-output-panel", size = { height = 15 } },
				{ title = "DB Query Result", ft = "dbout" },
			},
			left = {
				{ title = "Neotest Summary", ft = "neotest-summary" },
			},
			right = {
				{ title = "Grug Far", ft = "grug-far", size = { width = 0.4 } },
				{
					ft = "toggleterm",
					-- size = { height = 0.4 },
					size = { width = 0.4 },
					filter = function(buf, win)
						return vim.api.nvim_win_get_config(win).relative == ""
					end,
				},
				{
					ft = "copilot-chat",
					title = "Copilot-chat",
					size = { width = 50 },
				},
				{
					title = "Database",
					ft = "dbui",
					pinned = true,
					width = 0.3,
					open = function()
						vim.cmd("DBUI")
					end,
				},
			},
			keys = {
				-- increase width
				["<c-Right>"] = function(win)
					win:resize("width", 2)
				end,
				-- decrease width
				["<c-Left>"] = function(win)
					win:resize("width", -2)
				end,
				-- increase height
				["<c-Up>"] = function(win)
					win:resize("height", 2)
				end,
				-- decrease height
				["<c-Down>"] = function(win)
					win:resize("height", -2)
				end,
			},
		}

		for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
			opts[pos] = opts[pos] or {}
			table.insert(opts[pos], {
				ft = "trouble",
				filter = function(_buf, win)
					return vim.w[win].trouble
						and vim.w[win].trouble.position == pos
						and vim.w[win].trouble.type == "split"
						and vim.w[win].trouble.relative == "editor"
						and not vim.w[win].trouble_preview
				end,
			})
		end

		-- snack terminal
		for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
			opts[pos] = opts[pos] or {}
			table.insert(opts[pos], {
				ft = "snacks_terminal",
				size = { height = 0.4 },
				title = "%{b:snacks_terminal.id}: %{b:term_title}",
				filter = function(_buf, win)
					return vim.w[win].snacks_win
						and vim.w[win].snacks_win.position == pos
						and vim.w[win].snacks_win.relative == "editor"
						and not vim.w[win].trouble_preview
				end,
			})
		end
		return opts
	end,
}
