local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local utils = require("core.utils.general")

-- General Settings
local general = augroup("General Settings", { clear = true })

autocmd("BufEnter", {
	callback = function()
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
	group = general,
	desc = "Disable New Line Comment",
})

autocmd("BufEnter", {
	callback = function(opts)
		if vim.bo[opts.buf].filetype == "bicep" then
			vim.bo.commentstring = "// %s"
		end
	end,
	group = general,
	desc = "Set Bicep Comment String",
})

autocmd("BufEnter", {
	pattern = { "*.md", "*.txt" },
	callback = function()
		vim.opt_local.spell = true
	end,
	group = general,
	desc = "Enable spell checking on specific filetypes",
})

autocmd("FileType", {
	group = general,
	pattern = {
		"grug-far",
		"help",
		"checkhealth",
		"copilot-chat",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", {
			buffer = event.buf,
			silent = true,
			desc = "Quit buffer",
		})
	end,
})

autocmd("LspAttach", {
	group = general,
	callback = function(env)
		local client = vim.lsp.get_client_by_id(env.data.client_id)
		local keymap = function(mode, keys, func, desc)
			vim.keymap.set(mode, keys, func, { buffer = env.buf, desc = "LSP: " .. desc })
		end

    -- stylua: ignore start
		keymap("n", "gd", function() vim.lsp.buf.definition() end, "Go to definition")
		keymap("n", "K", function() vim.lsp.buf.hover() end, "Hover")
		keymap("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, "Workspace symbol")
		keymap("n", "<leader>vd", function() vim.diagnostic.open_float() end, "Float diagnostic")
		keymap("n", "<leader>ca", function() vim.lsp.buf.code_action() end, "Code action")
		keymap("n", "gr", function() vim.lsp.buf.references() end, "Go to references")
		keymap("n", "<leader>cr", function() vim.lsp.buf.rename() end, "Rename variable")
		keymap("i", "<C-k>", function() vim.lsp.buf.signature_help() end, "Signature help")
    keymap("n", "[d", function() vim.diagnostic.goto_prev() end, "Go to previous diagnostic message")
    keymap("n", "]d", function() vim.diagnostic.goto_next() end, "Go to next diagnostic message")
		-- stylua: ignore end

		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.HINT] = "󰌶",
					[vim.diagnostic.severity.INFO] = "",
				},
			},
			virtual_text = {
				spacing = 4,
				source = "if_many",
				prefix = "●",
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

		if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
			vim.lsp.inlay_hint.enable(true, { env.buf })
			keymap("n", "<leader>ti", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = env.buf }))
			end, "Toggle inlay hints")
		end
	end,
})
