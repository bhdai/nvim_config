vim.g.mapleader = " "

local function map(mode, lhs, rhs, desc)
	desc = desc or "none"
	vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

local in_vscode = vim.g.vscode ~= nil

if not in_vscode then
	-- this only run if you're  NOT in Vscode
	map("n", "<leader>ds", vim.diagnostic.setloclist, "lsp diagnostic loclist")

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
	map("n", "sv", ":vsplit<CR>")
	map("n", "ss", ":split<CR>")

	-- resize windows
	map("n", "<C-Left>", "<C-w><")
	map("n", "<C-Right>", "<C-w>>")
	map("n", "<C-Up>", "<C-w>+")
	map("n", "<C-Down>", "<C-w>-")

	-- neo_tree
	map("n", "<leader>r", ":Neotree focus<CR>")

	-- Add a custom keybinding to toggle the colorscheme
	vim.api.nvim_set_keymap("n", "<leader>tt", ":CyberdreamToggleMode<CR>", { noremap = true, silent = true })

	-- Move to previous/next
	map("n", "<A-,>", "<Cmd>BufferPrevious<CR>")
	map("n", "<A-.>", "<Cmd>BufferNext<CR>")
	-- Re-order to previous/next
	map("n", "<A-<>", "<Cmd>BufferMovePrevious<CR>")
	map("n", "<A->>", "<Cmd>BufferMoveNext<CR>")
	-- Goto buffer in position...
	map("n", "<A-1>", "<Cmd>BufferGoto 1<CR>")
	map("n", "<A-2>", "<Cmd>BufferGoto 2<CR>")
	map("n", "<A-3>", "<Cmd>BufferGoto 3<CR>")
	map("n", "<A-4>", "<Cmd>BufferGoto 4<CR>")
	map("n", "<A-5>", "<Cmd>BufferGoto 5<CR>")
	map("n", "<A-6>", "<Cmd>BufferGoto 6<CR>")
	map("n", "<A-7>", "<Cmd>BufferGoto 7<CR>")
	map("n", "<A-8>", "<Cmd>BufferGoto 8<CR>")
	map("n", "<A-9>", "<Cmd>BufferGoto 9<CR>")
	map("n", "<A-0>", "<Cmd>BufferLast<CR>")
	-- Pin/unpin buffer
	map("n", "<A-p>", "<Cmd>BufferPin<CR>")
	-- Goto pinned/unpinned buffer
	--                 :BufferGotoPinned
	--                 :BufferGotoUnpinned
	-- Close buffer
	map("n", "<A-c>", "<Cmd>BufferClose<CR>")
	-- Wipeout buffer
	--                 :BufferWipeout
	-- Close commands
	--                 :BufferCloseAllButCurrent
	--                 :BufferCloseAllButPinned
	--                 :BufferCloseAllButCurrentOrPinned
	--                 :BufferCloseBuffersLeft
	--                 :BufferCloseBuffersRight
	-- Magic buffer-picking mode
	map("n", "<C-p>", "<Cmd>BufferPick<CR>")
	-- Sort automatically by...
	map("n", "<Space>bb", "<Cmd>BufferOrderByBufferNumber<CR>")
	map("n", "<Space>bn", "<Cmd>BufferOrderByName<CR>")
	map("n", "<Space>bd", "<Cmd>BufferOrderByDirectory<CR>")
	map("n", "<Space>bl", "<Cmd>BufferOrderByLanguage<CR>")
	map("n", "<Space>bw", "<Cmd>BufferOrderByWindowNumber<CR>")

-- Other:
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used
else
	-- this will run if you ARE in Vscode
end

-- Keybinding that should work both in vscode and regular neovim

--exit insert mode you can enable it if you want here i comment it out cuz i prefer to map the esc key to CapsLook key using powertoy
-- map("n", "jk", "<ESC>")
--

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
map("v", "<leader>p", '"_dP')
map("n", "<leader>c", '"_c')
map("v", "<leader>c", '"_c')
map("v", "<leader>C", '"_C')
map("n", "<leader>d", '"_d')
map("n", "<leader>C", '"_C')
map("n", "<leader>D", '"_D')
map("v", "<leader>d", '"_d')
map("v", "<leader>D", '"_D')

-- select all
map("n", "<C-a>", "gg<S-v>G")
