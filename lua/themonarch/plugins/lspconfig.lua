return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		-- "hrsh7th/cmp-nvim-lsp", -- for autocompletion
		"j-hui/fidget.nvim", -- lsp process notification
		"saghen/blink.cmp",
	},
	config = function()
		local lspconfig = require("lspconfig")
		-- local cmp_lsp = require("cmp_nvim_lsp")
		-- local capabilities = vim.tbl_deep_extend(
		-- 	"force",
		-- 	{},
		-- 	vim.lsp.protocol.make_client_capabilities(),
		-- 	cmp_lsp.default_capabilities()
		-- )

		local capabilities = require("blink.cmp").get_lsp_capabilities()

		local virtual_text_config = {
			spacing = 4,
			source = "if_many",
			prefix = "icons",
		}

		local icons = require("core.icons")

		if virtual_text_config.prefix == "icons" then
			virtual_text_config.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
				or function(diagnostic)
					local diag_icons = icons.diagnostics
					for d, icon in pairs(diag_icons) do
						if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
							return icon
						end
					end
					return "●" -- fallback icon
				end
		end

		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
					[vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
					[vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
					[vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
				},
			},
			virtual_text = virtual_text_config,
			update_in_insert = false,
			underline = true,
			severity_sort = true,
			float = {
				focusable = true,
				style = "minimal",
				border = "none",
				source = true,
				header = "",
				prefix = "",
			},
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("LSPGroup", { clear = true }),
			callback = function(env)
				local client = vim.lsp.get_client_by_id(env.data.client_id)
				local keymap = function(mode, keys, func, desc)
					vim.keymap.set(mode, keys, func, { buffer = env.buf, desc = "LSP: " .. desc })
				end

        -- stylua: ignore start
        -- keymap("n", "gd", function() vim.lsp.buf.definition() end, "Go to definition")
        keymap("n", "K", function() vim.lsp.buf.hover() end, "Hover")
        keymap("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, "Workspace symbol")
        keymap("n", "<leader>vd", function() vim.diagnostic.open_float() end, "Float diagnostic")
        keymap("n", "<leader>ca", function() vim.lsp.buf.code_action() end, "Code action")
        keymap("n", "<leader>cr", function() vim.lsp.buf.rename() end, "Rename variable")
        keymap("i", "<C-k>", function() vim.lsp.buf.signature_help() end, "Signature help")
        keymap("n", "[d", function() vim.diagnostic.jump({count = -1, float = true}) end, "Go to previous diagnostic message")
        keymap("n", "]d", function() vim.diagnostic.jump({count = 1, float = true}) end, "Go to next diagnostic message")
				-- stylua: ignore end

				if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
					vim.lsp.inlay_hint.enable(true, { env.buf })
					keymap("n", "<leader>uh", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = env.buf }))
					end, "Toggle inlay hints")
				end
			end,
		})

		require("fidget").setup({})

		require("mason").setup({
			ui = {
				width = 0.8,
				height = 0.8,
				icons = {
					package_installed = "✓",
					package_uninstalled = "✗",
					package_pending = "⟳",
				},
			},
		})

    -- define which python lsp to use
    local my_python_lsp = vim.g.my_python_lsp or "pyright"
    local my_python_lint = vim.g.my_python_ruff or "ruff"

    local server_to_check = {"pyright", "basedpyright", "ruff", "ruff_lsp"}

    local servers = {}

    for _, server in ipairs(server_to_check) do
      local enable = (server == my_python_lsp) or (server == my_python_lint)
      servers[server] = servers[server] or {}
      servers[server].enable = enable
    end

		require("mason-lspconfig").setup({
			ensure_installed = {
        my_python_lsp,
        my_python_lint,
				"bashls",
				"clangd",
				"pyright",
				"lua_ls",
				"ts_ls",
        "jdtls",
			},

			handlers = {
				-- function(server_name)
				--       require("lspconfig")[server_name].setup({
				--         capabilities = capabilities,
				--       })
				-- end,

        function(server_name)
          if servers[server_name] ~= nil then
            if servers[server_name].enable then
              lspconfig[server_name].setup({
                capabilities = capabilities,
                settings = servers[server_name].settings or {},
              })
            end
          else
            -- for servers not in custom table, just set them up normally.
            lspconfig[server_name].setup({
              capabilities = capabilities,
            })
          end
        end,

				["lua_ls"] = function()
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
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
					})
				end,
        ["jdtls"] = function()
          return true -- avoid duplicate server
        end
			},
		})
	end,
}
