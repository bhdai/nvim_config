return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ globle = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
}
