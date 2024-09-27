return {
	"stevearc/conform.nvim",
	event = "BufReadPre",
	config = function()
		vim.g.disable_autoformat = false
		require("conform").setup({
			formatters_by_ft = {
				css = { "prettier" },
				go = { "goimports_reviser", "gofmt", "golines" },
				html = { "prettier" },
				javascript = { "prettier" },
				json = { "prettier" },
				lua = { "stylua" },
				fish = { "fish_indent" },
				markdown = { "prettier" },
				scss = { "prettier" },
				sh = { "shfmt" },
				templ = { "templ" },
				toml = { "taplo" },
				yaml = { "prettier" },
			},

			default_format_opts = {
				timeout_ms = 3000,
				async = false,
				quiet = false,
				lsp_format = "fallback",
			},

			-- funciton to conditionally format after save
			format_after_save = function()
				if not vim.g.disable_autoformat then
					if vim.bo.filetype == "ps1" then
						vim.lsp.buf.format()
					else
						return { lsp_format = "fallback" }
					end
				end
			end,

			formatters = {
				goimports_reviser = {
					command = "goimports-reviser",
					args = { "-output", "stdout", "$FILENAME" },
				},
			},
		})

		-- Toggle format on save
		vim.api.nvim_create_user_command("ConformToggle", function()
			vim.g.disable_autoformat = not vim.g.disable_autoformat
			print("Conform " .. (vim.g.disable_autoformat and "disabled" or "enabled"))
		end, {
			desc = "Toggle format on save",
		})
	end,
}
