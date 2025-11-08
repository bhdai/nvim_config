return {
	"stevearc/conform.nvim",
	dependencies = { "mason.nvim" },
	lazy = true,
	event = { "BufWritePre", "BufNewFile" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>cF",
			function()
				require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
			end,
			mode = { "n", "v" },
			desc = "Format Injected Langs",
		},

		{
			"<leader>wf",
			function()
				require("conform").format({
					lsp_fallback = true, -- use LSP formatting if no formatters
					async = true, -- formatting asynchronously
				}, function()
					print("Formatting completed!")
				end)
			end,
			desc = "formatting with all",
		},
	},
	opts = {
		-- Default format options
		default_format_opts = {
			timeout_ms = 3000,
			async = false, -- Not recommended to change
			quiet = false, -- Set to true to suppress notifications
			lsp_format = "fallback", -- Use LSP formatting as fallback
		},

		-- Map of filetype to formatters
		formatters_by_ft = {
			lua = { "stylua" },
			fish = { "fish_indent" },
			sh = { "shfmt" },
			bash = { "shfmt" },
			python = { "ruff_format" },
			["_"] = { "trim_whitespace" },
		},

		-- Customize formatters
		formatters = {
			dprint = {
				condition = function(self, ctx)
					return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
				end,
			},
			-- Make codespell more reliable and only run on text files
			codespell = {
				condition = function(self, ctx)
					-- Only run on text-like files, not binary files
					local textlike_fts = {
						"text",
						"markdown",
						"gitcommit",
						"NeogitCommitMessage",
						"rst",
						"asciidoc",
						"latex",
						"tex",
						"mail",
					}
					return vim.tbl_contains(textlike_fts, vim.bo[ctx.buf].filetype)
				end,
			},
		},

		format_on_save = {
			-- These options will be passed to conform.format()
			timeout_ms = 500,
			lsp_format = "fallback",
		},

		-- Set the log level. Use `:ConformInfo` to see the location of the log file.
		log_level = vim.log.levels.ERROR,
		-- Conform will notify you when a formatter errors
		notify_on_error = true,
		-- Conform will notify you when no formatters are available for the buffer
		notify_no_formatters = true,
	},
	config = function(_, opts)
		local conform = require("conform")

		conform.setup(opts)

		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
