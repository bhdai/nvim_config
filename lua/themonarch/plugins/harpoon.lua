return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		menu = {
			width = vim.api.nvim_win_get_width(0) - 4,
		},
		settings = {
			save_on_toggle = true,
		},
	},
	keys = function()
		local keys = {
			{
				"<leader>H",
				function()
					require("harpoon"):list():add()
				end,
				desc = "Harpoon File",
			},
			{
				"<leader>h",
				function()
					local harpoon = require("harpoon")
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end,
				desc = "Harpoon Quick Menu",
			},
		}
		for i = 1, 5 do
			table.insert(keys, {
				"<leader>" .. i,
				function()
					require("harpoon"):list():select(i)
				end,
				desc = "Harpoon to File " .. i,
			})
		end
		return keys
	end,
	config = function(_, opts)
		local harpoon = require("harpoon")
		harpoon:setup(opts)

		vim.api.nvim_create_autocmd({ "BufLeave", "ExitPre" }, {
			pattern = "*",
			callback = function()
				local filename = vim.fn.expand("%:p:.")
				local harpoon_marks = harpoon:list().items
				for _, mark in ipairs(harpoon_marks) do
					if mark.value == filename then
						mark.context.row = vim.fn.line(".")
						mark.context.col = vim.fn.col(".")
						return
					end
				end
			end,
		})
	end,
}
