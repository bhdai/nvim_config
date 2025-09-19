return {
	{
		"folke/noice.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		event = "VeryLazy",
		config = function()
			require("noice").setup({
				-- routes = {
				-- 	{
				-- 		filter = {
				-- 			event = "msg_show",
				-- 			any = {
				-- 				{ find = "%d+L, %d+B" },
				-- 				{ find = "; after #%d+" },
				-- 				{ find = "; before #%d+" },
				-- 			},
				-- 		},
				-- 		opts = { skip = true },
				-- 	},
				-- },
				presets = {
					bottom_search = true,
					long_message_to_split = true,
					lsp_doc_border = false,
				},
				cmdline = {
					view = "cmdline",
				},
			})
		end,
	},
}
