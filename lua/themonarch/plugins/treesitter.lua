return {
	{
		"nvim-treesitter/nvim-treesitter",
		version = false,
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
		init = function(plugin)
			require("lazy.core.loader").add_to_rtp(plugin)
			require("nvim-treesitter.query_predicates")
		end,
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		keys = {
			{ "<c-space>", desc = "Increment Selection" },
			{ "<bs>", desc = "Decrement Selection", mode = "x" },
		},
		opts_extend = { "ensure_installed" },
		---@type TSConfig
		---@diagnostic disable-next-line: missing-fields
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
			textobjects = {
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
			},
		},
	},
	{ "IndianBoy42/tree-sitter-just", event = "BufRead justfile", opts = {} },
	{
		"https://github.com/Samonitari/tree-sitter-caddy",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			opts = function(_, opts)
				require("nvim-treesitter.parsers").get_parser_configs().caddy = {
					install_info = {
						url = "https://github.com/Samonitari/tree-sitter-caddy",
						files = { "src/parser.c", "src/scanner.c" },
						branch = "master",
					},
					filetype = "caddy",
				}

				opts.ensure_installed = opts.ensure_installed or {}
				vim.list_extend(opts.ensure_installed, { "caddy" })
				vim.filetype.add({
					pattern = {
						["Caddyfile"] = "caddy",
					},
				})
			end,
		},
		event = "BufRead Caddyfile",
	},
}

