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
			python = function(bufnr)
				if require("conform").get_formatter_info("ruff_format", bufnr).available then
					return { "ruff_format" }
				else
					return { "isort", "black" }
				end
			end,
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

		-- Set this to change the default values when calling conform.format()
		-- This will also affect the default values for format_on_save/format_after_save
		format_on_save = function(bufnr)
			-- Don't format if the global variable is set
			if vim.g.disable_autoformat then
				return
			end
			return {
				timeout_ms = 500,
				lsp_format = "fallback",
			}
		end,
		-- If this is set, Conform will run the formatter asynchronously after save.
		-- It will pass the table to conform.format().
		-- This can also be a function that returns the table.
		format_after_save = function(bufnr)
			-- Don't format if the global variable is set
			if vim.g.disable_autoformat then
				return
			end
			return {
				lsp_format = "fallback",
			}
		end,

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

		-- Toggle format on save
		vim.api.nvim_create_user_command("ConformToggle", function()
			vim.g.disable_autoformat = not vim.g.disable_autoformat
			print("Conform " .. (vim.g.disable_autoformat and "disabled" or "enabled"))
		end, {
			desc = "Toggle format on save",
		})
	end,
}
