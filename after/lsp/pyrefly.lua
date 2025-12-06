local root_dir_pyrefly = function(bufnr, cb)
	local root = vim.fs.root(bufnr, {
		"pyproject.toml",
		"pyrefly.toml",
		".git",
	}) or vim.fn.expand("%:p:h")
	cb(root)
end
vim.lsp.config("pyrefly", {
	cmd = { "pyrefly", "lsp" },
	filetypes = { "python" },
	root_dir = root_dir_pyrefly,
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
})
