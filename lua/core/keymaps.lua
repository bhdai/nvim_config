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
	-- these only run if NOT in Vscode
	-- dev
	map("n", "<leader>tf", "<cmd>PlenaryBustedFile %<cr>", { desc = "Test" })

	-- quickly source file and run lua
	map("n", "<space>bx", "<cmd>source %<CR>", { desc = "Source current buffer" })
	map("n", "<space>x", ":.lua<CR>", { desc = "Execute current line" })
	map("v", "<space>x", ":.lua<CR>", { desc = "Execute selected lines" })

	-- utils.general.wezterm()
	utils.general.cowboy()
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

	-- git
	map("n", "<leader>gc", "<cmd>FzfLua git_commits<CR>", { desc = "Commits" })
	map("n", "<leader>gs", "<cmd>FzfLua git_status<CR>", { desc = "Status" })

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
  map("n", "gr", ":FzfLua lsp_references<cr>", { desc = "Goto References" })
  map("n", "gI", "<cmd>FzfLua lsp_implementations<CR>", { desc = "Goto Implementation" })
  map("n", "gd", "<cmd>FzfLua lsp_definitions<CR>", { desc = "Goto Definition" })
  map("n", "gy","<cmd>FzfLua lsp_typedefs", { desc = "Goto Type Definition" })
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

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move lines up" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move lines down" })
map("n", "J", "mzJ`z")

-- better up/down
-- map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
-- map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

map("n", "dw", 'vb"_d')

-- clean search with <esc>
map("n", "<ESC>", ":noh<CR><ESC>", { desc = "Escape and clear hlsearch" })

-- center cursor when using <C-u/d> for vertical move
-- map("n", "<C-u>", "<C-u>zz")
-- map("n", "<C-d>", "<C-d>zz")

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
