return {
	"scottmckendry/dashboard-nvim",
	event = "VimEnter",
	config = function()
		vim.cmd("highlight DashboardHeader guifg=#ffffff")
		require("dashboard").setup({
			theme = "hyper",
			hide = {
				statusline = false,
			},
			config = {
				week_header = { enable = true },
				shortcut = {
					{
						icon = "󰒲  ",
						icon_hl = "Boolean",
						desc = "Update ",
						group = "Directory",
						action = "Lazy update",
						key = "u",
					},
					{
						icon = "   ",
						icon_hl = "Boolean",
						desc = "Files ",
						group = "Statement",
						action = "FzfLua files",
						key = "f",
					},
					{
						icon = "   ",
						icon_hl = "Boolean",
						desc = "Recent ",
						group = "String",
						action = "FzfLua oldfiles",
						key = "r",
					},
					{
						icon = "   ",
						icon_hl = "Boolean",
						desc = "Grep ",
						group = "ErrorMsg",
						action = "FzfLua live_grep",
						key = "g",
					},
					{
						icon = "   ",
						icon_hl = "Boolean",
						desc = "Quit ",
						group = "WarningMsg",
						action = "qall!",
						key = "q",
					},
				},
				project = { enable = false },
				mru = { enable = false },
				footer = {},
			},
		})
	end,
}
