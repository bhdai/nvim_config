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
					lsp_doc_border = false,
				},
				-- Nvim forces 'cmdheight' to 0 while a UI is attached with ext_messages
				-- (:h vim.ui_attach), which leaves the native cmdline with no row to draw
				-- in. Both have to stay off to keep the stock cmdline visible.
				cmdline = {
					enabled = false,
				},
				messages = {
					enabled = false,
				},
			})
		end,
	},
}
