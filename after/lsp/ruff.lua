vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("RuffLspConfig", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)

		if client and (client.name == "ruff") then
			-- disable hover provider to avoid conflicts with other Python LSP servers
			client.server_capabilities.hoverProvider = false
		end
	end,
})
