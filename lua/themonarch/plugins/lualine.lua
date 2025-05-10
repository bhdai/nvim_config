return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "echasnovski/mini.icons" },
	opts = function()
		local utils = require("core.utils.general")
		local icons = require("core.icons")
		local copilot_colors = {
			[""] = utils.get_hlgroup("Comment"),
			["Normal"] = utils.get_hlgroup("Comment"),
			["Warning"] = utils.get_hlgroup("DiagnosticError"),
			["InProgress"] = utils.get_hlgroup("DiagnosticWarn"),
		}

		return {
			options = {
				component_separators = { left = " ", right = " " },
				section_separators = { left = " ", right = " " },
				theme = "auto",
				globalstatus = true,
				disabled_filetypes = { statusline = { "dashboard", "alpha" } },
			},
			sections = {
				lualine_a = {
					{
						"mode",
						icon = "",
						fmt = function(mode)
							return mode:lower()
						end,
					},
				},
				lualine_b = { { "branch", icon = "" } },
				lualine_c = {
					{
						"diagnostics",
						symbols = {
							error = icons.diagnostics.Error,
							warn = icons.diagnostics.Warn,
							info = icons.diagnostics.Info,
							hint = icons.diagnostics.Hint,
						},
					},
					{ "filetype", icon_only = true, separator = "", padding = { left = 0, right = 0 } },
					{
						"filename",
						padding = { left = 0, right = 0 },
            color = { gui = "bold" },
					},
					{
						function()
							local buffer_count = require("core.utils.general").get_buffer_count()

							return "+" .. buffer_count - 1 .. " "
						end,
						cond = function()
							return require("core.utils.general").get_buffer_count() > 1
						end,
						color = utils.get_hlgroup("Operator", nil),
						padding = { left = 0, right = 1 },
					},
					{
						function()
							local tab_count = vim.fn.tabpagenr("$")
							if tab_count > 1 then
								return vim.fn.tabpagenr() .. " of " .. tab_count
							end
						end,
						cond = function()
							return vim.fn.tabpagenr("$") > 1
						end,
						icon = "󰓩",
						color = utils.get_hlgroup("Special", nil),
					},
				},
				lualine_x = {
					{
						require("lazy.status").updates,
						cond = require("lazy.status").has_updates,
						color = utils.get_hlgroup("String"),
					},
					{
						function()
							local status = require("copilot.status").data
							return icons.kinds.Copilot .. (status.message or "")
						end,
						cond = function()
							local ok, clients = pcall(vim.lsp.get_clients, { name = "copilot", bufnr = 0 })
							return ok and #clients > 0
						end,
						color = function()
							if not package.loaded["copilot"] then
								return
							end
							local status = require("copilot.status").data
							return copilot_colors[status.status] or copilot_colors[""]
						end,
					},
					{ "diff" },
				},
				lualine_y = {
					{ "progress", padding = { left = 1, right = 1 } },
					{ "location", padding = { left = 0, right = 1 } },
				},
				lualine_z = {
					function()
						return " " .. os.date("%R")
					end,
				},
			},
			extensions = { "fzf", "mason", "lazy" },
		}
	end,
}
