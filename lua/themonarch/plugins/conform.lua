return {
	"stevearc/conform.nvim",
	event = { "VeryLazy", "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		formatters_by_ft = {
			javascript = { "prettierd", "prettier" },
			typescript = { "prettierd", "prettier" },
			javascriptreact = { "prettierd", "prettier" },
			typescriptreact = { "prettierd", "prettier" },
			css = { "prettierd", "prettier" },
			scss = { "prettier" },
			html = { "djlint", "prettierd", "prettier" },
			templ = { "djlint", "templ" },
			json = { "prettierd", "prettier" },
			jsonc = { "prettierd", "prettier" },
			rasi = { "prettierd", "prettier" },
			toml = { "taplo" },
			yaml = { "prettierd", "prettier" },
			fish = { "fish_indent" },
			markdown = { "prettierd", "prettier", "injected" },
			norg = { "injected" },
			graphql = { "prettierd", "prettier" },
			lua = { "stylua" },
			go = { "goimports", "gofumpt" },
			sh = { "beautysh", "shfmt" },
			python = { "isort", "ruff" },
			zig = { "zigfmt" },
			["_"] = { "trim_whitespace", "trim_newlines" },
			["*"] = { "codespell" },
		},
		formatters = {
			shfmt = {
				prepend_args = { "-i", "2" },
			},
			-- Dealing with old version of prettierd that doesn't support range formatting
			prettierd = {
				range_args = false,
			},
		},
		log_level = vim.log.levels.TRACE,
		format_after_save = { timeout_ms = 500, lsp_fallback = true, async = true, quiet = true },
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
