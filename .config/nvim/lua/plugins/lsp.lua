return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- mason-lspconfig v2 removed the `handlers` API and renamed `volar` → `vue_ls`.
      -- Per-server config now uses vim.lsp.config(); mason-lspconfig's
      -- automatic_enable feature calls vim.lsp.enable() once installed.
      vim.lsp.config("*", { capabilities = capabilities })

      vim.lsp.config("vue_ls", {
        capabilities = capabilities,
        filetypes = { "vue" },
      })

      vim.lsp.config("ts_ls", {
        capabilities = capabilities,
        -- Do not attach to .vue files (vue_ls handles those)
        filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
      })

      require("mason-lspconfig").setup({
        ensure_installed = {
          "vue_ls",         -- Vue (renamed from volar in mason-lspconfig v2)
          "ts_ls",          -- TypeScript
          "eslint",         -- ESLint
          "jsonls",         -- JSON
        },
      })

      -- LSP keymaps on attach
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local buf = event.buf
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
          end

          map("n", "gd", vim.lsp.buf.definition, "Go to definition")
          map("n", "gr", vim.lsp.buf.references, "Go to references")
          map("n", "R", vim.lsp.buf.rename, "Rename symbol")
          map("n", "K", vim.lsp.buf.hover, "Hover documentation")
          map("n", "}", vim.diagnostic.goto_next, "Next diagnostic")
          map("n", "{", vim.diagnostic.goto_prev, "Previous diagnostic")
          map("n", "ga", vim.lsp.buf.code_action, "Code action")
        end,
      })

    end,
  },
}
