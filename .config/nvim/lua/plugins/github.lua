return {
  "pwntester/octo.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  cmd = { "Octo" },
  keys = {
    { "<C-g>P", function()
      local dir = vim.fn.expand("%:p:h")
      local git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(dir) .. " rev-parse --show-toplevel 2>/dev/null")[1]
      if git_root and git_root ~= "" then
        vim.cmd("lcd " .. vim.fn.fnameescape(git_root))
      end
      vim.cmd("Octo pr list")
    end, desc = "List PRs" },
    { "<C-g>R", "<cmd>Octo review start<cr>", desc = "Start PR review" },
  },
  opts = {
    suppress_missing_scope = {
      projects_v2 = true,
    },
  },
}
