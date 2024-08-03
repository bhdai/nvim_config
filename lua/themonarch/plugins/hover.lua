return {
	"patrickpichler/hovercraft.nvim",

	dependencies = {
		{ "nvim-lua/plenary.nvim" },
	},

	-- this is the default config and can be skipped
	opts = function()
		return {
			providers = {
				providers = {
					{
						"LSP",
						require("hovercraft.provider.lsp.hover").new(),
					},
					{
						"Man",
						require("hovercraft.provider.man").new(),
					},
					{
						"Dictionary",
						require("hovercraft.provider.dictionary").new(),
					},
				},
			},

			window = {
				border = "single",
			},

			keys = {
				{
					"<C-u>",
					function()
						require("hovercraft").scroll({ delta = -4 })
					end,
				},
				{
					"<C-d>",
					function()
						require("hovercraft").scroll({ delta = 4 })
					end,
				},
				{
					"<TAB>",
					function()
						require("hovercraft").hover_next()
					end,
				},
				{
					"<S-TAB>",
					function()
						require("hovercraft").hover_next({ step = -1 })
					end,
				},
			},
		}
	end,

	keys = {
		{
			"K",
			function()
				local hovercraft = require("hovercraft")

				if hovercraft.is_visible() then
					hovercraft.enter_popup()
				else
					hovercraft.hover()
				end
			end,
		},
	},
}
