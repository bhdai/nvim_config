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
		lazy = false, -- set it to false to make sure it load during startup if it is your main theme
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				transparent = true,
				styles = {
					sidebars = "transparent",
					floats = "transparent",
				},
			})
			vim.cmd.colorscheme("tokyonight-storm")
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavor = "macchiato",
				background = {
					light = "latte",
					dark = "macchiato",
				},
				transparent_background = true,
				show_end_of_buffer = false,
				terminal_colors = true,
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{
		"scottmckendry/cyberdream.nvim",
		lazy = true,
		priority = 1000,
		config = function()
			require("cyberdream").setup({
				transparent = true,
				terminal_colors = false,
				cache = true,
				theme = {
					variant = "auto",
					overrides = function(colours)
						return {
							TelescopePromptPrefix = { fg = colours.blue },
							TelescopeMatching = { fg = colours.cyan },
							TelescopeResultsTitle = { fg = colours.blue },
							TelescopePromptCounter = { fg = colours.cyan },
							TelescopePromptTitle = { fg = colours.bg, bg = colours.blue, bold = true },
						}
					end,
				},
			})
			vim.cmd.colorscheme("cyberdream")
		end,
	},
}
