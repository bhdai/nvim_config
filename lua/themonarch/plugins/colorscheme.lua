return {
	"folke/tokyonight.nvim",
	lazy = true,
	priority = 1000,
	opts = {
		on_highlights = function(hl, c)
			hl.LineNr = { fg = "#565f89" }
			hl.LineNrAbove = { fg = "#565f89" }
			hl.LineNrBelow = { fg = "#565f89" }
		end,
	},
	init = function()
		vim.cmd.colorscheme("tokyonight-night")
	end,
}
