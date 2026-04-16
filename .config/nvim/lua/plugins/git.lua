return {
  -- Gitsigns: inline blame, hunk signs, hunk navigation
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      -- Matches gitlens.currentLine.enabled: false
      current_line_blame = false,
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- Hunk navigation on bare ]/[. Shadows native bracket sequences
        -- ([[, [{, [m, etc.) with a timeoutlen delay before the bare key
        -- fires — accepted tradeoff per user request.
        map("n", "]", function()
          if vim.wo.diff then return "]c" end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, "Next hunk")

        map("n", "[", function()
          if vim.wo.diff then return "[c" end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, "Previous hunk")

        -- Revert hunk (matches <C-g>r)
        map({ "n", "v" }, "<C-g>r", gs.reset_hunk, "Revert hunk")

        -- Preview hunk
        map("n", "<C-g>p", gs.preview_hunk, "Preview hunk")

        -- Blame
        map("n", "<C-g>b", function() gs.blame_line({ full = true }) end, "Blame line")
      end,
    },
  },

  -- Diffview: full diff UI (GitLens replacement)
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    keys = {
      -- Diff with previous commit (matches <C-g>d -> gitlens.diffWithPrevious)
      { "<C-g>d", "<cmd>DiffviewOpen HEAD~1 -- %<cr>", desc = "Diff with previous" },

      -- File history for current file (matches <C-g>D -> gitlens.diffWithRevisionFrom)
      { "<C-g>D", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (current)" },

      -- All changed files (matches <C-g>L -> gitlens.openOnlyChangedFiles)
      { "<C-g>L", "<cmd>DiffviewOpen<cr>", desc = "All changed files" },

      -- File history for repo (matches <C-g>l -> gitlens search and compare)
      { "<C-g>l", "<cmd>DiffviewFileHistory<cr>", desc = "File history (repo)" },

      -- Toggle inline/side-by-side (matches <C-g>i)
      {
        "<C-g>i",
        function()
          local view = require("diffview.lib").get_current_view()
          if view then
            -- Close diffview if open
            vim.cmd("DiffviewClose")
          else
            vim.cmd("DiffviewOpen")
          end
        end,
        desc = "Toggle diffview",
      },
    },
    opts = {
      enhanced_diff_hl = true,
    },
  },

  -- Fugitive: Git commands
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gblame", "Gdiffsplit", "Gread", "Gwrite" },
  },
}
