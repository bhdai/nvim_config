return {
	"stevearc/aerial.nvim",
	-- Optional dependencies
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{ "<leader>cs", "<cmd>AerialToggle<cr>", desc = "Aerial (Symbols)" },
	},
	opts = {
		attach_mode = "global",
		backends = { "lsp", "treesitter", "markdown", "man" },
		show_guides = true,
		layout = {
			resize_to_content = true,
			width = 20,
			win_opts = {
				winhl = "Normal:NormalFloat,FloatBorder:NormalFloat,SignColumn:SignColumnSB",
				signcolumn = "yes",
				statuscolumn = " ",
			},
		},
    -- stylua: ignore
    guides = {
      mid_item   = "├╴",
      last_item  = "└╴",
      nested_top = "│ ",
      whitespace = "  ",
    },
	},
}
