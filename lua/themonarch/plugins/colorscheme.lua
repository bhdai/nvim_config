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

    vim.api.nvim_set_hl(0, 'LineNr', { fg = "#565f89" })
    vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = "#565f89" })
    vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = "#565f89" })
  end,
}
