local my_python_ruff = vim.g.my_python_ruff or "ruff"
if my_python_ruff ~= "ruff_lsp" then
  return
end

require("lspconfig").ruff_lsp.setup({
})
