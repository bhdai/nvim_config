return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		version = false, -- Don't pin to releases (they're outdated)
		lazy = false, -- Main branch does NOT support lazy-loading
		build = ":TSUpdate",
		cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
		opts_extend = { "ensure_installed" },
		opts = {
			-- Directory to install parsers and queries to
			-- Defaults to stdpath('data')/site, but we specify it explicitly
			install_dir = vim.fn.stdpath("data") .. "/site",

			-- Languages to install (excluding bundled parsers in Neovim 0.10+)
			-- Bundled: c, lua, markdown, markdown_inline, vim, vimdoc, query
			ensure_installed = {
				"bash",
				"cmake",
				"css",
				"diff",
				"gitcommit",
				"gitignore",
				"git_config",
				"html",
				"java",
				"javascript",
				"jsdoc",
				"json",
				"jsonc",
				"luadoc",
				"luap",
				"python",
				"sql",
				"toml",
				"tsx",
				"typescript",
				"yaml",
			},

			-- REMOVED: incremental_selection is NOT available in main branch
			-- The following features are no longer configured here:
			-- - highlight (now handled via FileType autocmd)
			-- - indent (now handled via FileType autocmd)
			-- Main branch delegates these to Neovim core + manual setup
		},

		config = function(_, opts)
			vim.filetype.add({
				extension = { rasi = "rasi", rofi = "rasi", wofi = "rasi" },
				filename = {
					["vifmrc"] = "vim",
				},
				pattern = {
					[".*/waybar/config"] = "jsonc",
					[".*/mako/config"] = "dosini",
					[".*/kitty/.+%.conf"] = "kitty",
					[".*/hypr/.+%.conf"] = "hyprlang",
					["%.env%.[%w_.-]+"] = "sh",
				},
			})
			vim.treesitter.language.register("bash", "kitty")

			local function add(lang)
				if type(opts.ensure_installed) == "table" then
					table.insert(opts.ensure_installed, lang)
				end
			end

			local function have(name)
				return vim.fn.executable(name) == 1
			end

			-- Add languages based on available tools
			if have("hypr") then
				add("hyprlang")
			end

			if have("fish") then
				add("fish")
			end

			if have("rofi") or have("wofi") then
				add("rasi")
			end

			-- setup nvim-treesitter with main branch api
			local TS = require("nvim-treesitter")

			-- Sanity check: ensure we're on main branch with new API
			if not TS.get_installed then
				vim.notify(
					"nvim-treesitter: Please update to main branch! Use :Lazy and update the plugin.",
					vim.log.levels.ERROR
				)
				return
			end

			-- Setup with user options
			TS.setup(opts)

			-- Helper to check if a query exists for a language
			local function has_query(lang, query_name)
				return pcall(vim.treesitter.query.get, lang, query_name)
			end

			-- Manual installation of missing parsers (Main branch specific)
			vim.schedule(function()
				local installed = TS.get_installed and TS.get_installed() or {}
				-- If get_installed isn't available/reliable, we fallback to checking usage, but getting the list is best.
				
				local to_install = vim.tbl_filter(function(lang)
					return not vim.tbl_contains(installed, lang)
				end, opts.ensure_installed or {})

				if #to_install > 0 then
					-- Install missing parsers
					TS.install(to_install, { summary = false })
				end
			end)

			-- Autocmd to enable features (highlight, indent, fold)
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("treesitter_features", { clear = true }),
				callback = function(ev)
					local ft = ev.match
					local lang = vim.treesitter.language.get_lang(ft) or ft

					-- Parsers must be installed for features to work
					local has_parser = pcall(vim.treesitter.language.add, lang)
					if not has_parser then
						return
					end

					-- HIGHLIGHTING
					if has_query(lang, "highlights") then
						pcall(vim.treesitter.start, ev.buf)
					end

					-- INDENTATION
					if has_query(lang, "indents") then
						vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end

					-- FOLDING
					if has_query(lang, "folds") then
						vim.wo[0][0].foldmethod = "expr"
						vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
						vim.wo[0][0].foldlevel = 99
					end
				end,
			})
		end,
	},

	-- ============================================
	-- NVIM-TREESITTER-TEXTOBJECTS (Main Branch)
	-- ============================================
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main", -- Use main branch
		event = "VeryLazy",
		opts = {
			move = {
				enable = true,
				set_jumps = true, -- Add jumps to jumplist
				-- Keymaps will be set via function below
				-- (LazyVim pattern - buffer-local keymaps)
			},
		},

		config = function(_, opts)
			local TS = require("nvim-treesitter-textobjects")

			-- Sanity check
			if not TS.setup then
				vim.notify("nvim-treesitter-textobjects: Please update to main branch!", vim.log.levels.ERROR)
				return
			end

			-- Setup textobjects
			TS.setup(opts)

			-- ============================================
			-- BUFFER-LOCAL TEXTOBJECT KEYMAPS
			-- ============================================
			-- This follows LazyVim's pattern of creating buffer-local
			-- keymaps only for buffers with textobject queries
			local moves = {
				goto_next_start = {
					["]f"] = "@function.outer",
					["]c"] = "@class.outer",
					["]a"] = "@parameter.inner",
				},
				goto_next_end = {
					["]F"] = "@function.outer",
					["]C"] = "@class.outer",
					["]A"] = "@parameter.inner",
				},
				goto_previous_start = {
					["[f"] = "@function.outer",
					["[c"] = "@class.outer",
					["[a"] = "@parameter.inner",
				},
				goto_previous_end = {
					["[F"] = "@function.outer",
					["[C"] = "@class.outer",
					["[A"] = "@parameter.inner",
				},
			}

			-- Function to attach keymaps to a buffer
			local function attach_textobject_keymaps(buf)
				local ft = vim.bo[buf].filetype
				local lang = vim.treesitter.language.get_lang(ft)

				-- Check if textobjects query exists for this language
				local ok, _ = pcall(vim.treesitter.query.get, lang or ft, "textobjects")
				if not ok then
					return
				end

				-- Create buffer-local keymaps
				for method, keymaps in pairs(moves) do
					for key, query in pairs(keymaps) do
						-- Generate descriptive label
						local desc = query:gsub("@", ""):gsub("%..*", "")
						desc = desc:sub(1, 1):upper() .. desc:sub(2)
						desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
						desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")

						-- Skip c/C keys in diff mode (they're used for diff navigation)
						if not (vim.wo.diff and key:find("[cC]")) then
							vim.keymap.set({ "n", "x", "o" }, key, function()
								require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
							end, {
								buffer = buf,
								desc = desc,
								silent = true,
							})
						end
					end
				end
			end

			-- Attach to existing buffers
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_loaded(buf) then
					attach_textobject_keymaps(buf)
				end
			end

			-- Attach to future buffers via autocmd
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("treesitter_textobjects_keymaps", { clear = true }),
				callback = function(ev)
					attach_textobject_keymaps(ev.buf)
				end,
			})
		end,
	},

	-- ============================================
	-- NVIM-TREESITTER-CONTEXT (Unchanged)
	-- ============================================
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "VeryLazy",
		opts = function()
			local tsc = require("treesitter-context")
			Snacks.toggle({
				name = "Treesitter Context",
				get = tsc.enabled,
				set = function(state)
					if state then
						tsc.enable()
					else
						tsc.disable()
					end
				end,
			}):map("<leader>ut")
			return { mode = "cursor", max_lines = 3 }
		end,
	},

	-- ============================================
	-- NVIM-TS-AUTOTAG (Unchanged)
	-- ============================================
	{
		"windwp/nvim-ts-autotag",
		ft = { "html", "xml", "jsx" },
		opts = {},
	},
}
