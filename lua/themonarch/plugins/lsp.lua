return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim" },
		{ "williamboman/mason-lspconfig.nvim" },
		"j-hui/fidget.nvim",
		"Saghen/blink.cmp",
	},
	config = function()
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		require("fidget").setup({})
		require("mason").setup({
			ui = {
				width = 0.8,
				height = 0.8,
				icons = {
					package_installed = "",
					package_uninstalled = "",
					package_pending = "󱍷",
				},
			},
		})
		require("mason-lspconfig").setup({
			ensure_installed = { "lua_ls" },
			handlers = {
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,
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

		local icons = require("core.icons").diagnostics
		local diagnostic_icon = function(diagnostic)
			for severity, icon in pairs(icons) do
				if diagnostic.severity == vim.diagnostic.severity[severity:upper()] then
					return icon
				end
			end
			return "●" -- fallback icon
		end

		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = icons.Error,
					[vim.diagnostic.severity.WARN] = icons.Warn,
					[vim.diagnostic.severity.HINT] = icons.Hint,
					[vim.diagnostic.severity.INFO] = icons.Info,
				},
			},
			virtual_text = {
				spacing = 4,
				source = "if_many",
				prefix = vim.fn.has("nvim-0.10.0") == 0 and "●" or diagnostic_icon,
			},
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
	end,
}
