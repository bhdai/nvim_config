local my_python_lsp = vim.g.my_python_lsp or "pyright"
if my_python_lsp ~= "pyright" then
  return -- don't setup if not chosen
end

require("lspconfig").pyright.setup({
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
      },
    },
  },
})
