if not vim.g.vscode then
	return {}
end

local enabled = {
	"lazy.nvim",
	"mini.surround",
	"nvim-treesitter",
	"mini.comment",
	"flit.nvim",
	"leap.nvim",
}

local Config = require("lazy.core.config")
Config.options.checker.enabled = false
Config.options.change_detection.enabled = false
Config.options.defaults.cond = function(plugin)
	return vim.tbl_contains(enabled, plugin.name) or plugin.vscode
end
vim.g.snacks_animate = false

vim.api.nvim_create_autocmd("User", {
	pattern = "VSCodeNeovimKeymap",
	callback = function()
		vim.keymap.set("n", "<leader>P", "<cmd>Find<cr>")
		vim.keymap.set("n", "<leader>/", [[<cmd>lua require('vscode').action('workbench.action.findInFiles')<cr>]])
		vim.keymap.set("n", "<leader>ss", [[<cmd>lua require('vscode').action('workbench.action.gotoSymbol')<cr>]])

		-- sync undo/redo with vscode
		vim.keymap.set("n", "u", [[<cmd>lua require('vscode').action('undo')<cr>]])
		vim.keymap.set("n", "<C-r>", [[<cmd>lua require('vscode').action('redo')<cr>]])
	end,
})

vim.api.nvim_exec_autocmds("User", { pattern = "VSCodeNeovimKeymap" })

return {
	{
		"snacks.nvim",
		enabled = false,
		opts = {
			indent = { enabled = false },
			scroll = { enabled = false },
			notifier = { enabled = false },
			statuscolumn = { enabled = false },
			picker = { enabled = false },
		},
	},
	{
		"folke/lazy.nivm",
		config = function(_, opts)
			opts = opts or {}
			-- Insert lazy.nvim specific config here if needed
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			highlight = { enable = false },
		},
	},
}
