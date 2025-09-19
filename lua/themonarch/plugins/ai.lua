return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		build = ":Copilot auth",
		event = "BufReadPost",
		opts = {
			suggestion = {
				enabled = false,
				auto_trigger = true,
				hide_during_completion = false,
				keymap = {
					accept = false, -- this will be handled by blink.cmp
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
			},
			copilot_model = "gpt-4o-copilot",
			panel = { enabled = false },
			-- filetypes = { ["*"] = true },
			filetypes = {
				markdown = true,
				help = true,
			},
		},
		config = function(_, opts)
			-- set up copilot
			require("copilot").setup(opts)

			-- define the global ai_accept function
			vim.g.ai_accept = function()
				if require("copilot.suggestion").is_visible() then
					require("copilot.suggestion").accept()
					return true
				end
				return false
			end
		end,
	},
}
