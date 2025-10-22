return {
	"mfussenegger/nvim-jdtls",
	dependencies = { "folke/which-key.nvim" },
	ft = "java",
	config = function()
		local jdtls = require("jdtls")

		local function get_project_name(root_dir)
			return root_dir and vim.fs.basename(root_dir) or "default"
		end

		local function get_jdtls_config_dir(project_name)
			return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
		end

		local function get_jdtls_workspace_dir(project_name)
			return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
		end

		local function get_root_dir(fname)
			return vim.fs.root(fname, {
				"build.gradle",
				"build.gradle.kts",
				"build.xml", -- Ant
				"pom.xml", -- Maven
				"settings.gradle", -- Gradle
				"settings.gradle.kts", -- Gradle
				".git",
				"mvnw",
				"gradlew",
			})
		end

		local function attach_jdtls()
			local fname = vim.api.nvim_buf_get_name(0)
			local root_dir = get_root_dir(fname)
			local project_name = get_project_name(root_dir)

			-- Build the command for starting jdtls
			local cmd = { vim.fn.exepath("jdtls") }
			if cmd[1] == "" then
				vim.notify("jdtls not found in PATH", vim.log.levels.ERROR)
				return
			end

			-- Add lombok support if available
			local mason_registry_ok, mason_registry = pcall(require, "mason-registry")
			if mason_registry_ok and mason_registry.is_installed("jdtls") then
				local lombok_jar = vim.fn.expand("$HOME/.local/share/nvim/mason/share/jdtls/lombok.jar")
				if vim.fn.filereadable(lombok_jar) == 1 then
					table.insert(cmd, string.format("--jvm-arg=-javaagent:%s", lombok_jar))
				end
			end

			-- Add configuration and workspace directories
			vim.list_extend(cmd, {
				"-configuration",
				get_jdtls_config_dir(project_name),
				"-data",
				get_jdtls_workspace_dir(project_name),
			})

			-- Get blink.cmp capabilities if available
			local capabilities = nil
			local blink_ok, blink = pcall(require, "blink.cmp")
			if blink_ok then
				capabilities = blink.get_lsp_capabilities()
			end

			local config = {
				cmd = cmd,
				root_dir = root_dir,
				capabilities = capabilities,
				settings = {
					java = {
						inlayHints = {
							parameterNames = { enabled = "all" },
						},
					},
				},
				init_options = {
					bundles = {},
				},
			}

			jdtls.start_or_attach(config)
		end

		-- Setup keymaps after LSP attaches
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client and client.name == "jdtls" then
					local wk_ok, wk = pcall(require, "which-key")
					if wk_ok then
						wk.add({
							{
								mode = "n",
								buffer = args.buf,
								{ "<leader>cx", group = "extract" },
								{ "<leader>cxv", require("jdtls").extract_variable_all, desc = "Extract Variable" },
								{ "<leader>cxc", require("jdtls").extract_constant, desc = "Extract Constant" },
								{ "<leader>cgs", require("jdtls").super_implementation, desc = "Goto Super" },
								{ "<leader>co", require("jdtls").organize_imports, desc = "Organize Imports" },
							},
						})
						wk.add({
							{
								mode = "v",
								buffer = args.buf,
								{ "<leader>cx", group = "extract" },
								{
									"<leader>cxm",
									[[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
									desc = "Extract Method",
								},
								{
									"<leader>cxv",
									[[<ESC><CMD>lua require('jdtls').extract_variable_all(true)<CR>]],
									desc = "Extract Variable",
								},
								{
									"<leader>cxc",
									[[<ESC><CMD>lua require('jdtls').extract_constant(true)<CR>]],
									desc = "Extract Constant",
								},
							},
						})
					end
				end
			end,
		})

		-- Attach jdtls for each java buffer
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "java",
			callback = attach_jdtls,
		})

		-- Attach immediately if current buffer is already a Java file
		if vim.bo.filetype == "java" then
			attach_jdtls()
		end
	end,
}
