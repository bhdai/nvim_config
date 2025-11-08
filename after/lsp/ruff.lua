vim.lsp.config("ruff", {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_dir = function(bufnr, cb)
		local root = vim.fs.root(bufnr, {
			"pyproject.toml",
			"ruff.toml",
			".ruff.toml",
			".git",
		}) or vim.fn.expand("%:p:h")
		cb(root)
	end,
	on_attach = function(client, _)
		-- lsp use ruff to formatter
		client.server_capabilities.documentFormattingProvider = false -- enable vim.lsp.buf.format()
		client.server_capabilities.documentRangeFormattingProvider = false -- formatting will be used by confirm.nvim
		client.server_capabilities.hoverProvider = false -- use basedpyrigt
	end,
	init_options = {
		settings = {
			logLevel = "warn",
			organizeImports = true, -- use code action for organizeImports
			showSyntaxErrors = true, -- show syntax error diagnostics
			codeAction = {
				disableRuleComment = { enable = false }, -- show code action about rule disabling
				fixViolation = { enable = false }, -- show code action for autofix violation
			},
			format = {
				preview = false,
			},
			lint = {
				enable = true,
			},
		},
	},
	single_file_support = false,
})
