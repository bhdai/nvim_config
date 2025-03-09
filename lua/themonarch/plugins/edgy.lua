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
				-- "neo-tree",
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

		-- Replace LazyVim.has with a function to check if a plugin is installed
		local function has_plugin(plugin)
			return pcall(require, plugin) or vim.fn.exists("g:loaded_" .. plugin:gsub("%.", "_")) == 1
		end

		if has_plugin("neo-tree.nvim") then
			local pos = {
				filesystem = "left",
				buffers = "top",
				git_status = "right",
				document_symbols = "bottom",
				diagnostics = "bottom",
			}

			local function get_neo_tree_opts()
				local neo_tree_config = require("neo-tree.config")
				return neo_tree_config.options
			end

			local sources = get_neo_tree_opts().sources or {}
			for i, v in ipairs(sources) do
				table.insert(opts.left, i, {
					title = "Neo-Tree " .. v:gsub("_", " "):gsub("^%l", string.upper),
					ft = "neo-tree",
					filter = function(buf)
						return vim.b[buf].neo_tree_source == v
					end,
					pinned = true,
					open = function()
						-- Replace LazyVim.root() with vim.fn.getcwd()
						vim.cmd(("Neotree show position=%s %s dir=%s"):format(pos[v] or "bottom", v, utils.get_root()))
					end,
				})
			end
		end

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
		return opts
	end,
}
