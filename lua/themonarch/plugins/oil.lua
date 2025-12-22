return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {},
	dependencies = { "nvim-tree/nvim-web-devicons" },
	lazy = false,
	key = {
		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" }),
	},
	config = function(_, opts)
		require("oil").setup({
			columns = { "icons" },
			keymaps = {
				["<C-h>"] = false,
				["<C-l>"] = false,
				["<C-r>"] = "actions.refresh",
			},
			view_options = {
				show_hidden = true,
			},
		})
	end,
}
