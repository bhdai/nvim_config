vim.g.mapleader = " "
local utils = require("core.utils")

local map = function(modes, lhs, rhs, opts)
	local options = { silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	if type(modes) == "string" then
		modes = { modes }
	end
	for _, mode in ipairs(modes) do
		vim.keymap.set(mode, lhs, rhs, options)
	end
end

local in_vscode = vim.g.vscode ~= nil

if not in_vscode then
	utils.general.wezterm()
	-- this only run if you're NOT in Vscode
	map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "lsp diagnostic loclist" })

	-- lazy
	map("n", "<leader>l", ":Lazy<CR>", { desc = "toggle lazy.nvim buffer" })

	-- Move to window using the <ctrl> hjkl keys
	map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
	map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
	map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
	map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

	-- new windows
	map("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })
	map("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true })
	map("n", "<leader>wd", "<C-W>c", { desc = "delete window", remap = true })

	-- Resize window using <ctrl> arrow keys
	map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
	map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
	map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
	map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

	-- Telescope
	map("n", "<leader>ff", ":Telescope find_files<cr>", { desc = "Fuzzy find files" })
	map("n", "<leader>fr", ":Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
	map("n", "<leader>fs", ":Telescope live_grep<cr>", { desc = "Find string in CWD" })
	map("n", "<leader>fc", ":Telescope grep_string<cr>", { desc = "Find string under cursor in CWD" })
	map("n", "<leader>fb", ":Telescope buffers<cr>", { desc = "Fuzzy find buffers" })
	map("n", "<leader>ft", ":Telescope<cr>", { desc = "Other pickers..." })
	map("n", "<leader>fS", ":Telescope resession<cr>", { desc = "Find Session" })
	map("n", "<leader>fh", ":Telescope help_tags<cr>", { desc = "Find help tags" })

  -- stylua: ignore start
  map("n", "<leader>df", function() utils.general.telescope_diff_file() end, { desc = "Diff file with current buffer" })
  map("n", "<leader>dr", function() utils.general.telescope_diff_file(true) end, { desc = "Diff recent file with current buffer" })
  map("n", "<leader>dg", function() utils.general.telescope_diff_from_history() end, { desc = "Diff from git history" })
	-- stylua: ignore end

	-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
	vim.keymap.set("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
	vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
	vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
	vim.keymap.set("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
	vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
	vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

  -- Code/LSP
  -- stylua: ignore start
  map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
  map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
  map("n", "<leader>cl", ":LspInfo<cr>", { desc = "LSP Info" })
  map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
  map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
  map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
  map("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
  map("n", "gr", ":Telescope lsp_references<cr>", { desc = "Goto References" })
  map("n", "gI", function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end, { desc = "Goto Implementation" })
  map("n", "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end, { desc = "Goto Definition" })
  map("n", "gy", function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, { desc = "Goto Type Definition" })
	-- stylua: ignore end

	-- -- floating terminal
	-- local lazyterm = function()
	-- 	utils.terminal(nil, { cwd = utils.general.get_root() })
	-- end
	-- map("n", "<leader>tt", lazyterm, { desc = "Terminal (Root Dir)" })
	-- map("n", "<leader>tT", function()
	-- 	utils.terminal()
	-- end, { desc = "Terminal (cwd)" })
	-- map("n", "<c-/>", lazyterm, { desc = "Terminal (Root Dir)" })
	-- map("n", "<c-_>", lazyterm, { desc = "which_key_ignore" })

	-- neo_tree
	map("n", "<leader>R", ":Neotree focus<CR>")

	-- enable/disable render-markdown
	map("n", "<leader>um", ":RenderMarkdown toggle<CR>")

	map("n", "]t", function()
		require("todo-comments").jump_next()
	end, { desc = "Next todo comment" })

	map("n", "[t", function()
		require("todo-comments").jump_prev()
	end, { desc = "Previous todo comment" })
else
	-- this will run if you ARE in Vscode
end

-- Keybinding that should work both in vscode and regular neovim

--exit insert mode you can enable it if you want here i comment it out cuz i prefer to map the esc key to CapsLook key using powertoy
-- map("n", "jk", "<ESC>")

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
map("n", "dw", 'vb"_d')

-- clean search with <esc>
map("n", "<ESC>", ":noh<CR><ESC>", { desc = "Escape and clear hlsearch" })

-- center cursor when using <C-u/d> for vertical move
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-d>", "<C-d>zz")

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- Do things without affecting the registers
map("n", "x", '"_x')
map("n", "c", '"_c')
map("v", "c", '"_c')
map("v", "C", '"_C')
map("n", "C", '"_C')
map("v", "p", '"_dP')
map("n", "<leader>d", '"_d')
map("n", "<leader>D", '"_D')
map("v", "<leader>d", '"_d')
map("v", "<leader>D", '"_D')

-- select all
map("n", "<C-a>", "gg<S-v>G")

-- change word with <c-c>
map({ "n", "x" }, "<C-c>", "<cmd>normal! ciw<cr>a")
