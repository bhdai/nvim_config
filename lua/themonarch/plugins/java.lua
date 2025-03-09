return {
  "mfussenegger/nvim-jdtls",
  dependencies = { "folke/which-key.nvim" },
  ft = "java",
  config = function ()
    local home = os.getenv('HOME')
    local jdtls = require('jdtls')

    local function start_jdtls()
      local workspace_dir = home .. "/.cache/jdtls_workspace/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

      -- get the path to jdtls executable
      local jdtls_bin = vim.fn.exepath("jdtls")
      if jdtls_bin == "" then
        vim.notify("jdtls not found in PATH", vim.log.levels.ERROR)
        return
      end

      -- build the command for starting jdtls
      local cmd = { jdtls_bin}

      -- set up a configuration directory
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
      local config_dir = vim.fn.stdpath("cache") .. "/jdtls_config/" .. project_name
      table.insert(cmd, "-configuration")
      table.insert(cmd, config_dir)
      table.insert(cmd, "-data")
      table.insert(cmd, workspace_dir)

      local config = {
        cmd = cmd,
        -- find the project root by looking for markers like .git, mvnw, or gradlew
        root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),
        -- basic settings
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

      -- start the jdtls server
      jdtls.start_or_attach(config)
    end

    -- create an autocmd so that jdtls attaches when a Java file is opened.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      callback = function()
        start_jdtls()
      end,
    })

    -- if the current buffer is already a Java file, attach immediately.
    if vim.bo.filetype == "java" then
      start_jdtls()
    end

    -- set up some key mappings using which-key if installed.
    local wk_status, wk = pcall(require, "which-key")
    if wk_status then
      wk.register({
        ["<leader>co"] = { jdtls.organize_imports, "Organize Imports" },
        ["<leader>cxv"] = { jdtls.extract_variable_all, "Extract Variable" },
      }, { buffer = 0 })
    end
  end
}
