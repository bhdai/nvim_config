vim.lsp.config("basedpyright", {
	cmd = { "basedpyright-langserver", "--stdio" },
	filetypes = { "python" },
	on_attach = function(client, _)
		client.server_capabilities.completionProvider = false -- use pyrefly for fast response
		client.server_capabilities.definitionProvider = false -- use pyrefly for fast response
		client.server_capabilities.documentHighlightProvider = false -- use pyrefly for fast response
		client.server_capabilities.renameProvider = false -- use pyrefly as I think it is stable
		client.server_capabilities.semanticTokensProvider = false -- use pyrefly it is more rich
	end,
	settings = {
		basedpyright = {
			disableOrganizeImports = true, -- use ruff instead of it
			analysis = {
				autoImportCompletions = true,
				autoSearchPaths = true, -- auto serach command paths like 'src'
				useLibraryCodeForTypes = true,
				diagnosticSeverityOverrides = {
					reportAny = "none",
				},
			},
		},
	},
})
