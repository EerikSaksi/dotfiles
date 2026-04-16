return {
  "kylechui/nvim-surround",
  event = { "BufReadPost", "BufNewFile" },
  init = function()
    -- Disable defaults so we can bind sa/sr/sd via <Plug> (v4 API)
    vim.g.nvim_surround_no_mappings = true
  end,
  config = function()
    require("nvim-surround").setup()

    local map = vim.keymap.set
    map("n", "sa", "<Plug>(nvim-surround-normal)", { desc = "Add surround" })
    map("n", "sd", "<Plug>(nvim-surround-delete)", { desc = "Delete surround" })
    map("n", "sr", "<Plug>(nvim-surround-change)", { desc = "Change surround" })
    map("v", "sa", "<Plug>(nvim-surround-visual)", { desc = "Add surround (visual)" })
  end,
}
