local root_dir_basedpyright = function(bufnr, cb)
	local root = vim.fs.root(bufnr, {
		"pyproject.toml",
		"pyrightconfig.json",
		".git",
	}) or vim.fn.expand("%:p:h")
	cb(root)
end

vim.lsp.config("basedpyright", {
	cmd = { "basedpyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_dir = root_dir_basedpyright,
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
				diagnosticMode = "openFilesOnly",
				useLibraryCodeForTypes = true,
			},
		},
	},
})
