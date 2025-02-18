--TODO: switch to fzf-lua
return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap", "mfussenegger/nvim-dap-python", --optional
    { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
  },
  lazy = false,
  branch = "regexp",
  opts = {
    settings = {
      options = {
        notify_user_on_venv_activation = true,
      },
      search = {
        anaconda_envs = {
          command = [[fd 'bin/python$' ~/miniforge3/envs --full-path --color never -E /proc]]
        },
        anaconda_base = {
          command = [[fd '/python$' ~/miniforge3/bin --full-path --color never -E /proc]],
        },
      }
    }
  },
  keys = { { "<leader>cv", "<cmd>: VenvSelect<cr>", desc= "Select VirtualEnv", ft = "python"}},
}
