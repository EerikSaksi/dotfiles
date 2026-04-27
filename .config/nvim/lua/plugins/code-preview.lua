return {
  "Cannon07/code-preview.nvim",
  event = "VeryLazy",
  config = function()
    require("code-preview").setup({
      diff = {
        layout = "tab",
        equalize = true,
        full_file = true,
      },
    })
  end,
}
