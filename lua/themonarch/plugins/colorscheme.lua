return{
  "folke/tokyonight.nvim",
  priority = 1000,
  opts = {
    transparent = true,
    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },
  },
  config = function()
    vim.cmd.colorscheme("tokyonight")
  end,
}
