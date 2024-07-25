if not vim.g.vscode then
	return {}
end

local enabled = {
	"lazy.nvim",
	"mini.move",
	"nvim-treesitter",
	"yanky.nvim",
	"sqlite.lua",
}

local Config = require("lazy.core.config")
Config.options.checker.enabled = false
Config.options.change_detection.enabled = false
Config.options.defaults.cond = function(plugin)
	return vim.tbl_contains(enabled, plugin.name) or plugin.vscode
end

-- Add some vscode specific keymaps
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		vim.keymap.set("n", "<leader>p", "<cmd>Find<cr>")
		vim.keymap.set("n", "<leader>/", [[<cmd>call VSCodeNotify('workbench.action.findInFiles')<cr>]])
		vim.keymap.set("n", "<leader>ss", [[<cmd>call VSCodeNotify('workbench.action.gotoSymbol')<cr>]])
		vim.keymap.set("n", "<leader><space>", [[<cmd>call VSCodeNotify('whichkey.show')<cr>]])
		vim.keymap.set("v", "<leader><space>", [[<cmd>call VSCodeNotify('whichkey.show')<cr>]])
	end,
})

return {
	{
		"folke/lazy.nivm",
		config = function(_, opts)
			opts = opts or {}
			-- Insert lazy.nvim specific config here if needed
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { highlight = { enable = false } },
	},
}
