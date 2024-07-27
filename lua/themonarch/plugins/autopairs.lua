return {
	"windwp/nvim-autopairs",
	vscode = false,
	event = "InsertEnter",
	config = function()
		require("nvim-autopairs").setup({
			disable_filetype = { "TelescopePrompt", "vim" },
		})
	end,
}
