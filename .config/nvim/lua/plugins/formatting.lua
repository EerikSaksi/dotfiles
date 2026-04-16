return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      typescript = { "prettier" },
      javascript = { "prettier" },
      typescriptreact = { "prettier" },
      javascriptreact = { "prettier" },
      vue = { "prettier" },
      json = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      html = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      lua = { "stylua" },
    },
  },
}
