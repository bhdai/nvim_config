return {
	"sphamba/smear-cursor.nvim",
	event = "VeryLazy",
	cond = vim.g.neovide == nil,
	opts = {
		use_floating_windows = true,
		legacy_computing_symbols_support = true,
		distance_stop_animating = 0.5,
		stiffness = 0.8,
		hide_target_hack = true,
		cursor_color = "none",
	},
}
