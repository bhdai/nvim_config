return {
	{
		"linux-cultist/venv-selector.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"mfussenegger/nvim-dap",
			"mfussenegger/nvim-dap-python", --optional
		},
		lazy = false,
		branch = "regexp",
		opts = {
			settings = {
				options = {
					notify_user_on_venv_activation = true,
					picker = "fzf-lua",
				},
				search = {
					anaconda_envs = {
						command = [[fd 'bin/python$' ~/miniforge3/envs --full-path --color never -E /proc]],
					},
					anaconda_base = {
						command = [[fd '/python$' ~/miniforge3/bin --full-path --color never -E /proc]],
					},
				},
			},
		},
		keys = { { "<leader>cv", "<cmd>: VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" } },
	},
	{
		"Vigemus/iron.nvim",
		-- command = {"Iron", "IronRepl", "IronFocus", "IronHide", "IronStop" },
		config = function()
			local iron = require("iron.core")
			local view = require("iron.view")
			local common = require("iron.fts.common")

			iron.setup({
				config = {
					-- Whether a repl should be discarded or not
					scratch_repl = true,
					-- Your repl definitions come here
					repl_definition = {
						sh = {
							-- Can be a table or a function that
							-- returns a table (see below)
							command = { "fish" },
						},
						python = {
							command = { "ipython", "--no-autoindent" }, -- or { "ipython", "--no-autoindent" }
							format = common.bracketed_paste_python,
							block_dividers = { "# %%", "#%%" },
						},
					},
					-- set the file type of the newly created repl to ft
					-- bufnr is the buffer id of the REPL and ft is the filetype of the
					-- language being used for the REPL.
					repl_filetype = function(bufnr, ft)
						return ft
						-- or return a string name such as the following
						-- return "iron"
					end,
					-- How the repl window will be displayed
					-- See below for more information
					-- repl_open_cmd = view.bottom(40),
          repl_open_cmd = "vertical botright 80 split"

					-- repl_open_cmd can also be an array-style table so that multiple
					-- repl_open_commands can be given.
					-- When repl_open_cmd is given as a table, the first command given will
					-- be the command that `IronRepl` initially toggles.
					-- Moreover, when repl_open_cmd is a table, each key will automatically
					-- be available as a keymap (see `keymaps` below) with the names
					-- toggle_repl_with_cmd_1, ..., toggle_repl_with_cmd_k
					-- For example,
					--
					-- repl_open_cmd = {
					--   view.split.vertical.rightbelow("%40"), -- cmd_1: open a repl to the right
					--   view.split.rightbelow("%25")  -- cmd_2: open a repl below
					-- }
				},
				-- Iron doesn't set keymaps by default anymore.
				-- You can set them here or manually add keymaps to the functions in iron.core
				keymaps = {
					toggle_repl = "<space>rr", -- toggles the repl open and closed.
					-- If repl_open_command is a table as above, then the following keymaps are
					-- available
					-- toggle_repl_with_cmd_1 = "<space>rv",
					-- toggle_repl_with_cmd_2 = "<space>rh",
					restart_repl = "<space>rR", -- calls `IronRestart` to restart the repl
					send_motion = "<space>rc",
					visual_send = "<space>rp",
					send_file = "<space>rsf",
					send_line = "<space>rl",
					send_until_cursor = "<space>ru",
					send_mark = "<space>rm",
					send_code_block = "<space>rsb",
					send_code_block_and_move = "<space>rsn",
					-- mark_motion = "<space>rc",
					-- mark_visual = "<space>rc",
					remove_mark = "<space>rd",
					cr = "<space>s<cr>",
					interrupt = "<space>s<space>",
					exit = "<space>rq",
					clear = "<space>cl",
				},
				-- If the highlight is on, you can change how it looks
				-- For the available options, check nvim_set_hl
				highlight = {
					italic = true,
				},
				ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
			})

			-- iron also has a list of commands, see :h iron-commands for all available commands
			vim.keymap.set("n", "<space>rf", "<cmd>IronFocus<cr>")
			vim.keymap.set("n", "<space>rh", "<cmd>IronHide<cr>")
		end,
	},
}
