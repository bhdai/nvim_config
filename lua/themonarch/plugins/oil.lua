return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {},
	dependencies = { "nvim-tree/nvim-web-devicons" },
	key = {
		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" }),
	},
	config = function(_, opts)
		require("oil").setup({
			columns = { "icons" },
			keymaps = {
				["< C-h >"] = false,
			},
			view_options = {
				show_hidden = true,
			},
		})
	end,
}
