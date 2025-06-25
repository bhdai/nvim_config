require("lspconfig").lua_ls.setup({
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
    }
  }
})
