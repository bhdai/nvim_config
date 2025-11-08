-- note: capabilities are set by mason-lspconfig's automatic_enable
vim.lsp.config.lua_ls = {
	settings = {
		Lua = {
			workspace = {
				checkThirdParty = false,
			},
			codeLens = {
				enabled = true,
			},
			completion = {
				callSnippet = "Replace",
			},
			doc = {
				privateName = { "^_" },
			},
			hint = {
				enable = true,
				setType = false,
				paramType = true,
				paramName = "Disable",
				semicolon = "Disable",
				arrayIndex = "Disable",
			},
			diagnostics = {
				globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
			},
		},
	},
}
