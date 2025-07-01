vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client.name == 'ruff' or client.name == 'ruff_lsp' then
      client.server_capabilities.hoverProvider = false
    end
  end
})
