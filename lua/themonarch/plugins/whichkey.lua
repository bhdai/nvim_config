return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function()
		local wk = require("which-key")
		wk.setup({
			preset = "helix",
			icons = {
				rules = false,
			},
		})
		wk.add({
			{
				mode = { "n", "v" },
				{ "<leader>b", group = "buffer" },
				{ "<leader>c", group = "code" },
				{ "<leader>d", group = "diff" },
				{ "<leader>e", group = "explorer" },
				{ "<leader>f", group = "file/find" },
				{ "<leader>g", group = "git" },
				{ "<leader>rl", group = "lua" },
				{ "<leader>rs", group = "shell" },
				{ "<leader>s", group = "search" },
				{ "<leader>t", group = "toggle/trouble" },
				{ "<leader>w", group = "windows" },
				{ "<leader>x", group = "diagnostics/quickfix" },
			},
		})
	end,
}
