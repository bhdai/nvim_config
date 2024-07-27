if not vim.g.vscode then
	return {}
end

local enabled = {
	"lazy.nvim",
	"mini.move",
	"mini.surround",
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

vim.api.nvim_create_autocmd("User", {
	pattern = "VscodeNeovimKeyMaps",
	callback = function()
		vim.keymap.set("n", "<leader>P", "<cmd>Find<cr>")
		vim.keymap.set("n", "<leader>/", [[<cmd>call VSCodeNotify('workbench.action.findInFiles')<cr>]])
		vim.keymap.set("n", "<leader>ss", [[<cmd>call VSCodeNotify('workbench.action.gotoSymbol')<cr>]])
		vim.keymap.set("v", "<leader><space>", [[<cmd>call VSCodeNotify('whichkey.show')<cr>]])
		vim.keymap.set("n", "<leader><space>", [[<cmd>call VSCodeNotify('whichkey.show')<cr>]])

		-- if you fine with just fzf in the current directory use this
		-- vim.keymap.set("n", "<leader>ff", [[<cmd>call VSCodeNotify('binocular.searchFile')<cr>]]) -- Search by file name
		-- vim.keymap.set("n", "<leader>fd", [[<cmd>call VSCodeNotify('binocular.searchDirectory')<cr>]]) -- Search by directory name

		-- for the custom path you have to specific in your setting.json
		vim.keymap.set("n", "<leader>ff", [[<cmd>call VSCodeNotify('binocular.searchFileConfiguredFolders')<cr>]]) -- Search by file name
		vim.keymap.set("n", "<leader>fd", [[<cmd>call VSCodeNotify('binocular.searchDirectoryConfiguredFolders')<cr>]]) -- Search by directory name
		vim.keymap.set("n", "<leader>fg", [[<cmd>call VSCodeNotify('binocular.searchFileHistory')<cr>]]) --  Search file history
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
