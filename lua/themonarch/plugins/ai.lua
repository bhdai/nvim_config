return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	build = ":Copilot auth",
	event = "BufReadPost",
	opts = {
		suggestion = {
			enabled = true,
			auto_trigger = true,
			hide_during_completion = false,
			keymap = {
				accept = "<F1>",
				next = "<M-]>",
				prev = "<M-[>",
				dismiss = "<C-]>",
			},
		},
		panel = { enabled = false },
		filetypes = { ["*"] = true },
	},
}
