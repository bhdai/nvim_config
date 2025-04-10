return {
	{
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
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			-- { "github/copilot.vim" },
      { "zbirenbaum/copilot.lua" },
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			-- See Configuration section for options
		},
		-- See Commands section for default commands if you want to lazy load on them
	},
}
