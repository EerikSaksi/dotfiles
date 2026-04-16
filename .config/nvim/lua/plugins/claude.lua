return {
  "greggh/claude-code.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<C-b>", "<cmd>ClaudeCode<cr>", mode = { "n", "v", "i" }, desc = "Toggle Claude Code" },
  },
  opts = {
    window = {
      position = "botright vsplit",
      split_ratio = 0.35,
    },
  },
}
