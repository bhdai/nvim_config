return {
	cmd = { "pyrefly", "lsp" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "pyrefly.toml", ".git" },
	on_attach = function(client, _)
		client.server_capabilities.codeActionProvider = false -- basedpyright has more kinds
		client.server_capabilities.documentSymbolProvider = false -- basedpyright has more kinds
		client.server_capabilities.hoverProvider = false -- basedpyright has more kinds
		client.server_capabilities.inlayHintProvider = false -- basedpyright has more kinds
		client.server_capabilities.referenceProvider = false -- basedpyright has more kinds
		client.server_capabilities.signatureHelpProvider = false -- basedpyright has more kinds
		client.handlers["textDocument/publishDiagnostics"] = function() end
	end,
	settings = {},
}
