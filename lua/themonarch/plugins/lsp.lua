return {
	"neovim/nvim-lspconfig",
	-- event = "VeryLazy",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "williamboman/mason.nvim" },
		{ "williamboman/mason-lspconfig.nvim" },
		"j-hui/fidget.nvim",
		"Saghen/blink.cmp",
	},
	config = function()
		require("fidget").setup({})

		require("mason").setup({
			ui = {
				width = 0.8,
				height = 0.8,
			},
		})

		-- configure global LSP capabilities for all servers
		-- this will be inherited by all servers unless overridden
		vim.lsp.config("*", {
			capabilities = require("blink.cmp").get_lsp_capabilities(),
		})

		require("mason-lspconfig").setup({
			ensure_installed = { "lua_ls" },
			automatic_enable = true, -- automatically enables servers using vim.lsp.enable()
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				local bufnr = args.buf

				local function map(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = "LSP: " .. desc })
				end

				-- custom keymaps
				map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
				map("n", "<leader>vws", vim.lsp.buf.workspace_symbol, "Workspace Symbol")
				map("n", "<leader>vd", vim.diagnostic.open_float, "Show Diagnostic")
				map("n", "[d", function()
					vim.diagnostic.jump({ count = -1, float = true })
				end, "Previous Diagnostic")
				map("n", "]d", function()
					vim.diagnostic.jump({ count = 1, float = true })
				end, "Next Diagnostic")
				map("n", "gI", "<cmd>FzfLua lsp_implementations<CR>", "Goto Implementation")

				-- document highlighting
				-- Only set up document highlighting if the capability is not explicitly disabled
				if client and client.server_capabilities.documentHighlightProvider ~= false then
					local highlight_group = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						group = highlight_group,
						buffer = bufnr,
						callback = function()
							-- Double-check that the method is supported before calling
							if client:supports_method("textDocument/documentHighlight") then
								vim.lsp.buf.document_highlight()
							end
						end,
					})
					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						group = highlight_group,
						buffer = bufnr,
						callback = vim.lsp.buf.clear_references,
					})
				end
			end,
		})

		-- diagnostics display
		local icons = require("core.icons").diagnostics
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
				prefix = function(diagnostic)
					for severity, icon in pairs(icons) do
						if diagnostic.severity == vim.diagnostic.severity[severity:upper()] then
							return icon
						end
					end
					return "●"
				end,
			},
			update_in_insert = false,
			underline = true,
			severity_sort = true,
			float = {
				border = "none",
				source = "if_many",
				header = "Diagnostics:",
				prefix = "",
			},
		})
	end,
}
