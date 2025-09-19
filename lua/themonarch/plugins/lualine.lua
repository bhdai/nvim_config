return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = function()
		local utils = require("core.utils.general")
		local icons = require("core.icons")
		local copilot_colors = {
			[""] = utils.get_hlgroup("Comment"),
			["Normal"] = utils.get_hlgroup("Comment"),
			["Warning"] = utils.get_hlgroup("DiagnosticError"),
			["InProgress"] = utils.get_hlgroup("DiagnosticWarn"),
		}

		local function hl_by_state(default_hl)
			local name = vim.bo.modified and "WarningMsg" or vim.bo.readonly and "ErrorMsg" or default_hl
			local hl = utils.get_hlgroup(name, nil)
			hl.gui = "bold"
			if name == default_hl then
				hl.fg = "#ffffff"
			end
			return hl
		end

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
						color = {
							gui = "bold",
						},
					},
				},
				lualine_b = { { "branch", icon = "" } },
				lualine_c = {
					{
						function()
							local root = utils.get_root({ detectors = { "pattern" } })
							local name = vim.fn.fnamemodify(root, ":t")
							-- return " " .. name
							return "󰂖 " .. name
						end,
						cond = function()
							return utils.get_root({ detectors = { "pattern" } }) ~= nil
						end,
						color = utils.get_hlgroup("Directory", nil),
						padding = { left = 0, right = 1 },
						separator = { right = "" },
					},
					{
						"diagnostics",
						symbols = {
							error = icons.diagnostics.Error,
							warn = icons.diagnostics.Warn,
							info = icons.diagnostics.Info,
							hint = icons.diagnostics.Hint,
						},
						separator = "",
					},
					{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
					{
						function()
							local file_path = vim.api.nvim_buf_get_name(0)
							if file_path == "" then
								return ""
							end

							if vim.fn.fnamemodify(file_path, ":p:h") == vim.loop.cwd() then
								return ""
							end

							local root = utils.get_root({ detectors = { "pattern" } })
							local file_dir
							if root then
								local rel_path = vim.fs.normalize(file_path):gsub(vim.fs.normalize(root), "")
								if rel_path:sub(1, 1) == "/" then
									rel_path = rel_path:sub(2)
								end
								file_dir = vim.fn.fnamemodify(rel_path, ":h")
							else
								file_dir = vim.fn.fnamemodify(file_path, ":.:h")
							end

							if file_dir == "." or file_dir == "" then
								return ""
							end

							local shortened_path = vim.fn.pathshorten(file_dir)
							if shortened_path == "." then
								return ""
							end

							return shortened_path .. "/"
						end,
						padding = { left = 0, right = 0 },
						color = { fg = utils.get_hlgroup("Comment").fg },
						separator = "",
					},
					{
						"filename",
						path = 0, -- only show the filename
						padding = { left = 0, right = 0 },
						color = function()
							return hl_by_state("LualineFilename")
						end,
						symbols = {
							modified = "", -- already handled by hl_by_state color
							readonly = "󰦝",
							unnamed = " [No Name]",
						},
					},
					{
						function()
							local n = utils.get_buffer_count() - 1
							return (n > 0 and ("  " .. n) or "")
						end,
						cond = function()
							return utils.get_buffer_count() > 1
						end,
						color = utils.get_hlgroup("Operator", nil),
						padding = { left = 0, right = 0 },
					},
					{
						function()
							local cur = vim.fn.tabpagenr()
							local total = vim.fn.tabpagenr("$")
							return total > 1 and (cur .. "/" .. total) or ""
						end,
						cond = function()
							return vim.fn.tabpagenr("$") > 1
						end,
						icon = "",
						color = function()
							local total = vim.fn.tabpagenr("$")
							return total > 5 and utils.get_hlgroup("WarningMsg", nil)
								or utils.get_hlgroup("Special", nil)
						end,
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
					{
						"diff",
						symbols = {
							added = icons.git.added,
							modified = icons.git.modified,
							removed = icons.git.removed,
						},
						source = function()
							local gitsigns = vim.b.gitsigns_status_dict
							if gitsigns then
								return {
									added = gitsigns.added,
									modified = gitsigns.changed,
									removed = gitsigns.removed,
								}
							end
						end,
					},
				},
				lualine_y = {
					{
						function()
							local current_line = vim.fn.line(".")
							local total_lines = vim.fn.line("$")
							local percent = math.floor((current_line / total_lines) * 100)
							return " " .. percent .. "%%"
						end,
						padding = { left = 1, right = 0 },
					},
				},
				lualine_z = {
					{
						function()
							return " " .. vim.fn.line(".") .. "|" .. vim.fn.col(".")
						end,
						padding = { left = 1, right = 1 },
						color = {
							gui = "bold",
						},
					},
				},
			},
			extensions = { "fzf", "mason", "lazy" },
		}
	end,
}
