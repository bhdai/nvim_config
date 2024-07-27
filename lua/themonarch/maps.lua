vim.g.mapleader = " "

local function map(mode, lhs, rhs)
	vim.keymap.set(mode, lhs, rhs, { silent = true })
end

--exit insert mode you can enable it if you want here i comment it out cuz i prefer to map the esc key to CapsLook key using powertoy
-- map("n", "jk", "<ESC>")
--

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

-- neo_tree
map("n", "<leader>e", ":Neotree toggle<CR>")
map("n", "<leader>r", ":Neotree focus<CR>")

-- new windows
map("n", "sv", ":vsplit<CR>")
map("n", "ss", ":split<CR>")

-- windows navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- resize windows
map("n", "<C-Left>", "<C-w><")
map("n", "<C-Right>", "<C-w>>")
map("n", "<C-Up>", "<C-w>+")
map("n", "<C-Down>", "<C-w>-")
