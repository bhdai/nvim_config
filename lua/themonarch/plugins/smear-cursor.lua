return {
	"sphamba/smear-cursor.nvim",
	opts = {
		smear_between_buffers = true, -- smear cursor when switching buffers
		-- Use floating windows to display smears over wrapped lines or outside buffers.
		-- May have performance issues with other plugins.
		use_floating_windows = true,

		-- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
		-- Smears will blend better on all backgrounds.
		legacy_computing_symbols_support = false,
		distance_stop_animating = 0.5,
	},
}
