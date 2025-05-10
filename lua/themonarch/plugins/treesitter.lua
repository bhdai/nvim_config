local textobject_opts = {
	move = {
		enable = true,
		goto_next_start = {
			["]f"] = "@function.outer",
			["]c"] = "@class.outer",
			["]a"] = "@parameter.inner",
		},
		goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
		goto_previous_start = {
			["[f"] = "@function.outer",
			["[c"] = "@class.outer",
			["[a"] = "@parameter.inner",
		},
		goto_previous_end = {
			["[F"] = "@function.outer",
			["[C"] = "@class.outer",
			["[A"] = "@parameter.inner",
		},
	},
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		keys = {
			{ "<c-space>", desc = "Increment Selection" },
			{ "<bs>", desc = "Decrement Selection", mode = "x" },
		},
		opts = {
			highlight = { enable = true },
			indent = { enable = true },
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"javascript",
				"jsdoc",
				"json",
				"jsonc",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"printf",
				"python",
				"query",
				"regex",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"xml",
				"yaml",
				"cmake",
				"css",
				"devicetree",
				"gitcommit",
				"gitignore",
				"glsl",
				"go",
				"graphql",
				"http",
				"kconfig",
				"meson",
				"ninja",
				"rst",
				"nix",
				"org",
				"php",
				"scss",
				"sql",
				"svelte",
				"vue",
				"wgsl",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
			textobjects = textobject_opts,
		},
		config = function(_, opts)
			local function add(lang)
				if type(opts.ensure_installed) == "table" then
					table.insert(opts.ensure_installed, lang)
				end
			end

			vim.filetype.add({
				extension = { rasi = "rasi", rofi = "rasi", wofi = "rasi" },
				filename = {
					["vifmrc"] = "vim",
				},
				pattern = {
					[".*/waybar/config"] = "jsonc",
					[".*/mako/config"] = "dosini",
					[".*/kitty/.+%.conf"] = "kitty",
					[".*/hypr/.+%.conf"] = "hyprlang",
					["%.env%.[%w_.-]+"] = "sh",
				},
			})
			vim.treesitter.language.register("bash", "kitty")

			local have = function(name)
				return vim.fn.executable(name) == 1
			end

			add("git_config")

			if have("hypr") then
				add("hyprlang")
			end

			if have("fish") then
				add("fish")
			end

			if have("rofi") or have("wofi") then
				add("rasi")
			end

			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = "VeryLazy",
		enabled = true,
		config = function()
			-- If treesitter is already loaded, we need to run config again for textobjects
			if package.loaded["nvim-treesitter.configs"] then
				require("nvim-treesitter.configs").setup({ textobjects = textobject_opts })
			end

			-- When in diff mode, we want to use the default
			-- vim text objects c & C instead of the treesitter ones.
			local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
			local configs = require("nvim-treesitter.configs")
			for name, fn in pairs(move) do
				if name:find("goto") == 1 then
					move[name] = function(q, ...)
						if vim.wo.diff then
							local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
							for key, query in pairs(config or {}) do
								if q == query and key:find("[%]%[][cC]") then
									vim.cmd("normal! " .. key)
									return
								end
							end
						end
						return fn(q, ...)
					end
				end
			end
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		-- event = "LazyFile",
		opts = function()
			local tsc = require("treesitter-context")
			Snacks.toggle({
				name = "Treesitter Context",
				get = tsc.enabled,
				set = function(state)
					if state then
						tsc.enable()
					else
						tsc.disable()
					end
				end,
			}):map("<leader>ut")
			return { mode = "cursor", max_lines = 3 }
		end,
	},
}
