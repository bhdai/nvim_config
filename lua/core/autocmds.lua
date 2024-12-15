local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local utils = require("core.utils.general")

-- General Settings
local general = augroup("General Settings", { clear = true })

autocmd("TextYankPost", {
	desc = "Hight light when yanking text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

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
