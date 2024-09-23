return {
	"folke/todo-comments.nvim",
	cmd = "TodoTelesope",
	event = "BufRead",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{ "<leader>fd", "<cmd>TodoTelescope<cr>", desc = "Todo" },
	},
	opts = {},
}
