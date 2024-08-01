return {
	{
		"tiagovla/tokyodark.nvim",
		lazy = true,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme tokyodark]])
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = true, -- set it to false to make sure it load during startup if it is your main theme
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme tokyonight]])
		end,
		opts = {
			transparent = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
		},
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
		priority = 1000,
		opts = {
			flavor = "macchiato",
			background = {
				light = "latte",
				dark = "macchiato",
			},
			transparent_background = true,
			show_end_of_buffer = false,
			terminal_colors = true,
		},
		config = function()
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{
		"scottmckendry/cyberdream.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("cyberdream")
		end,
		opts = {
			transparent = true,
			borderless_telescope = true,
			terminal_colors = true,
			cache = true,
		},
	},
}
