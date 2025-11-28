return {
	"mfussenegger/nvim-jdtls",
	dependencies = {
		"folke/which-key.nvim",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	ft = { "java" },
	opts = function()
		local mason_path = vim.fn.stdpath("data") .. "/mason"
		local lombok_jar = mason_path .. "/packages/jdtls/lombok.jar"
		local launcher_jar = vim.fn.glob(mason_path .. "/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")
		local jdtls_config_dir = mason_path .. "/packages/jdtls/config_linux"

		local function get_java_path(ver)
			return "/usr/lib/jvm/java-" .. ver .. "-openjdk"
		end

		return {
			root_dir = function(fname)
				local build_file = vim.fs.root(fname, { "pom.xml", "build.gradle", "mvnw", "gradlew" })
				if build_file then
					return build_file
				end
				return vim.fs.root(fname, { ".git" })
			end,

			project_name = function(root_dir)
				return root_dir and vim.fs.basename(root_dir)
			end,

			jdtls_workspace_dir = function(project_name)
				return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
			end,

			full_cmd = function(opts)
				local fname = vim.api.nvim_buf_get_name(0)
				local root_dir = opts.root_dir(fname)
				local project_name = opts.project_name(root_dir)

				local java_launcher = get_java_path("21") .. "/bin/java"

				local cmd = {
					java_launcher,
					"-Declipse.application=org.eclipse.jdt.ls.core.id1",
					"-Dosgi.bundles.defaultStartLevel=4",
					"-Declipse.product=org.eclipse.jdt.ls.core.product",
					"-Dlog.protocol=true",
					"-Dlog.level=ALL",
					"-Xms1g",
					"--add-modules=ALL-SYSTEM",
					"--add-opens",
					"java.base/java.util=ALL-UNNAMED",
					"--add-opens",
					"java.base/java.lang=ALL-UNNAMED",
					"-jar",
					launcher_jar,
					"-configuration",
					jdtls_config_dir,
					"-data",
					opts.jdtls_workspace_dir(project_name),
				}

				if vim.fn.filereadable(lombok_jar) == 1 then
					table.insert(cmd, string.format("--jvm-arg=-javaagent:%s", lombok_jar))
				end

				return cmd
			end,

			settings = {
				java = {
					configuration = {
						runtimes = {
							{
								name = "JavaSE-17",
								path = get_java_path("17"),
								default = true,
							},
							{
								name = "JavaSE-21",
								path = get_java_path("21"),
							},
						},
					},
				},
			},
		}
	end,

	config = function(_, opts)
		local function attach_jdtls()
			local fname = vim.api.nvim_buf_get_name(0)
			local root_dir = opts.root_dir(fname)

			if not root_dir then
				return
			end

			local client_name = "jdtls"
			local active_clients = vim.lsp.get_clients({ name = client_name, bufnr = 0 })
			if #active_clients > 0 then
				return
			end

			local config = {
				cmd = opts.full_cmd(opts),
				root_dir = root_dir,
				settings = opts.settings,
				capabilities = require("blink.cmp").get_lsp_capabilities(),
				init_options = { bundles = {} },
			}

			require("jdtls").start_or_attach(config)
		end

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "java",
			callback = attach_jdtls,
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client and client.name == "jdtls" then
					local wk = require("which-key")
					wk.add({
						{
							mode = "n",
							buffer = args.buf,
							{ "<leader>cx", group = "extract" },
							{ "<leader>cxv", require("jdtls").extract_variable_all, desc = "Extract Variable" },
							{ "<leader>cxc", require("jdtls").extract_constant, desc = "Extract Constant" },
							{ "<leader>co", require("jdtls").organize_imports, desc = "Organize Imports" },
						},
					})
				end
			end,
		})

		if vim.bo.filetype == "java" then
			attach_jdtls()
		end
	end,
}
