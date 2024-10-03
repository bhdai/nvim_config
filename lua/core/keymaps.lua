vim.g.mapleader = " "
local utils = require("core.utils")

local function map(mode, lhs, rhs, desc)
	desc = desc or "none"
	vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

local in_vscode = vim.g.vscode ~= nil

if not in_vscode then
	utils.wezterm()
	-- this only run if you're NOT in Vscode
	map("n", "<leader>ds", vim.diagnostic.setloclist, "lsp diagnostic loclist")

	-- lazy
	map("n", "<leader>l", ":Lazy<CR>", "toggle lazy.nvim buffer")

	map("i", "<C-b>", "<ESC>^i", "move beginning of line")
	map("i", "<C-e>", "<End>", "move end of line")
	map("i", "<C-h>", "<Left>", "move left")
	map("i", "<C-l>", "<Right>", "move right")
	map("i", "<C-j>", "<Down>", "move down")
	map("i", "<C-k>", "<Up>", "move up")

	-- windows navigation
	map("n", "<C-h>", "<C-w>h")
	map("n", "<C-j>", "<C-w>j")
	map("n", "<C-k>", "<C-w>k")
	map("n", "<C-l>", "<C-w>l")

	-- new windows
	map("n", "<leader>-", "<C-W>s", "Split window below")
	map("n", "<leader>|", "<C-W>v", "Split window right")
	map("n", "<leader>wd", "<C-W>c", "delete window")

	-- resize windows
	map("n", "<C-Left>", "<C-w><")
	map("n", "<C-Right>", "<C-w>>")
	map("n", "<C-Up>", "<C-w>+")
	map("n", "<C-Down>", "<C-w>-")

	-- Telescope
	map("n", "<leader>ff", ":Telescope find_files<cr>", "Fuzzy find files")
	map("n", "<leader>fr", ":Telescope oldfiles<cr>", "Find string in CWD")
	map("n", "<leader>fc", ":Telescope grep_string<cr>", "Find string under cursor in CWD")
	map("n", "<leader>fb", ":Telescope buffers<cr>", "Fuzzy find buffers")
	map("n", "<leader>ft", ":Telescope<cr>", "Other pickers...")
	map("n", "<leader>fS", ":Telescope resession<cr>", "Find Session")
	map("n", "<leader>fh", ":Telescope help_tags<cr>", "Find help tags")

  -- stylua: ignore start
  map("n", "<leader>df", function() utils.telescope_diff_file() end, "Diff file with current buffer")
  map("n", "<leader>dr", function() utils.telescope_diff_file(true) end, "Diff recent file with current buffer")
  map("n", "<leader>dg", function() utils.telescope_diff_from_history() end, "Diff from git history")
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
  map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
  map("n", "<leader>cd", vim.diagnostic.open_float, "Line Diagnostics")
  map("n", "<leader>cl", ":LspInfo<cr>", "LSP Info")
  map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
  map("n", "K", vim.lsp.buf.hover, "Hover")
  map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
  map("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
  map("n", "gr", ":Telescope lsp_references<cr>", "Goto References")
  map("n", "gI", function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end, "Goto Implementation")
  map("n", "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end, "Goto Definition")
  map("n", "gy", function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, "Goto Type Definition")
	-- stylua: ignore end

	-- neo_tree
	map("n", "<leader>r", ":Neotree focus<CR>")

	-- enalbe/disable render-markdown
	map("n", "<leader>um", ":RenderMarkdown toggle<CR>")

	map("n", "]t", function()
		require("todo-comments").jump_next()
	end, "Next todo comment")

	map("n", "[t", function()
		require("todo-comments").jump_prev()
	end, "Previous todo comment")
else
	-- this will run if you ARE in Vscode
end

-- Keybinding that should work both in vscode and regular neovim

--exit insert mode you can enable it if you want here i comment it out cuz i prefer to map the esc key to CapsLook key using powertoy
-- map("n", "jk", "<ESC>")

-- better up and down
map("n", "j", "gj")
map("n", "k", "gk")
map("v", "j", "gj")
map("v", "k", "gk")

map("n", "dw", 'vb"_d')
-- clean search with <esc>
map("n", "<ESC>", ":noh<CR><ESC>")

-- center cursor when using <C-u/d> for vertical move
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-d>", "<C-d>zz")

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

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
