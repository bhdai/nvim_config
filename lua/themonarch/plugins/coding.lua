return {
	{
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
			layout = { min_width = 28 },
			filter_kind = false,
      -- stylua: ignore
      guides = {
        mid_item = "├ ",
        last_item = "└ ",
        nested_top = "│ ",
        whitespace = "  ",
      },
			keymaps = {
				["[y"] = "actions.prev",
				["]y"] = "actions.next",
				["[Y"] = "actions.prev_up",
				["]Y"] = "actions.next_up",
				["{"] = false,
				["}"] = false,
				["[["] = false,
				["]]"] = false,
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" }, -- equivalent to LazyFile event
		opts = {
			-- Event to trigger linters
			events = { "BufWritePost", "BufReadPost", "InsertLeave" },
			linters_by_ft = {
				fish = { "fish" },
			},
			linters = {},
		},
		config = function(_, opts)
			local M = {}

			local lint = require("lint")
			for name, linter in pairs(opts.linters) do
				if type(linter) == "table" and type(lint.linters[name]) == "table" then
					lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
					if type(linter.prepend_args) == "table" then
						lint.linters[name].args = lint.linters[name].args or {}
						vim.list_extend(lint.linters[name].args, linter.prepend_args)
					end
				else
					lint.linters[name] = linter
				end
			end
			lint.linters_by_ft = opts.linters_by_ft

			function M.debounce(ms, fn)
				local timer = vim.uv.new_timer()
				return function(...)
					local argv = { ... }
					timer:start(ms, 0, function()
						timer:stop()
						vim.schedule_wrap(fn)(unpack(argv))
					end)
				end
			end

			function M.lint()
				-- Use nvim-lint's logic first:
				-- * checks if linters exist for the full filetype first
				-- * otherwise will split filetype by "." and add all those linters
				-- * this differs from conform.nvim which only uses the first filetype that has a formatter
				local names = lint._resolve_linter_by_ft(vim.bo.filetype)

				-- Create a copy of the names table to avoid modifying the original.
				names = vim.list_extend({}, names)

				-- Add fallback linters.
				if #names == 0 then
					vim.list_extend(names, lint.linters_by_ft["_"] or {})
				end

				-- Add global linters.
				vim.list_extend(names, lint.linters_by_ft["*"] or {})

				-- Filter out linters that don't exist or don't match the condition.
				local ctx = { filename = vim.api.nvim_buf_get_name(0) }
				ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
				names = vim.tbl_filter(function(name)
					local linter = lint.linters[name]
					if not linter then
						vim.notify("Linter not found: " .. name, vim.log.levels.WARN, { title = "nvim-lint" })
					end
					return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
				end, names)

				-- Run linters.
				if #names > 0 then
					lint.try_lint(names)
				end
			end

			vim.api.nvim_create_autocmd(opts.events, {
				group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
				callback = M.debounce(100, M.lint),
			})
		end,
	},
	{
		"ThePrimeagen/refactoring.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
    -- stylua: ignore start
    keys = {
      { "<leader>r",  "",                                                                         desc = "+refactor",             mode = { "n", "v" } },
      { "<leader>rs", function() require("telescope").extensions.refactoring.refactors() end,     mode = "v",                     desc = "Refactor", },
      { "<leader>ri", function() require("refactoring").refactor("Inline Variable") end,          mode = { "n", "v" },            desc = "Inline Variable", },
      { "<leader>rb", function() require("refactoring").refactor("Extract Block") end,            desc = "Extract Block", },
      { "<leader>rf", function() require("refactoring").refactor("Extract Block To File") end,    desc = "Extract Block To File", },
      { "<leader>rP", function() require("refactoring").debug.printf({ below = false }) end,      desc = "Debug Print", },
      { "<leader>rp", function() require("refactoring").debug.print_var({ normal = true }) end,   desc = "Debug Print Variable", },
      { "<leader>rc", function() require("refactoring").debug.cleanup({}) end,                    desc = "Debug Cleanup", },
      { "<leader>rf", function() require("refactoring").refactor("Extract Function") end,         mode = "v",                     desc = "Extract Function", },
      { "<leader>rF", function() require("refactoring").refactor("Extract Function To File") end, mode = "v",                     desc = "Extract Function To File", },
      { "<leader>rx", function() require("refactoring").refactor("Extract Variable") end,         mode = "v",                     desc = "Extract Variable", },
      { "<leader>rp", function() require("refactoring").debug.print_var() end,                    mode = "v",                     desc = "Debug Print Variable", },
    },
		-- stylua: ignore end
		opts = {
			prompt_func_return_type = {
				go = false,
				java = false,
				cpp = false,
				c = false,
				h = false,
				hpp = false,
				cxx = false,
			},
			prompt_func_param_type = {
				go = false,
				java = false,
				cpp = false,
				c = false,
				h = false,
				hpp = false,
				cxx = false,
			},
			printf_statements = {},
			print_var_statements = {},
			show_success_message = true, -- shows a message with information about the refactor on success
			-- i.e. [Refactor] Inlined 3 variable occurrences
		},
		config = function(_, opts)
			require("refactoring").setup(opts)
			-- Check if telescope is available
			local ok, telescope = pcall(require, "telescope")
			if ok then
				telescope.load_extension("refactoring")
			end
		end,
	},
	{
		"smiteshp/nvim-navic",
		config = function()
			require("nvim-navic").setup({
				lsp = {
					auto_attach = true,
					-- priority order for attaching LSP servers
					-- to the current buffer
					preference = {
						"html",
						"templ",
					},
				},
				separator = " 󰁔 ",
			})
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		dependencies = { "mason.nvim" },
		opts = function(_, opts)
			local nls = require("null-ls")
			opts.root_dir = opts.root_dir
				or require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git")
			opts.source = vim.list_extend(opts.sources or {}, {
				nls.builtins.formatting.fish_indent,
				nls.builtins.diagnostics.fish,
				nls.builtins.formatting.stylua,
				nls.builtins.formatting.shfmt,
				nls.builtins.diagnostics.markdownlint_cli2,
			})
		end,
	},
	{
		"stevearc/resession.nvim",
		lazy = false,
		config = function()
			local resession = require("resession")

			local function is_vimpager()
				local args = vim.v.argv
				for i, arg in ipairs(args) do
					if arg == "-c" and args[i + 1]:match("lua require%('core.utils.general'%).colorize%(%)") then
						return true
					end
				end
				return false
			end

			resession.setup({})
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					-- Only load the session if nvim was started with no args and not in pager mode
					if vim.fn.argc(-1) == 0 and not is_vimpager() then
						-- Save these to a different directory, so our manual sessions don't get polluted
						resession.load(vim.fn.getcwd(), { silence_errors = true })
					end
				end,
				nested = true,
			})
			vim.api.nvim_create_autocmd("VimLeavePre", {
				callback = function()
					-- don't save session if in pager mode
					if not is_vimpager() then
						resession.save(vim.fn.getcwd(), { notify = true })
					end
				end,
			})
		end,
	},
}
