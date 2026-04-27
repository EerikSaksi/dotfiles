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

        -- Skip gitsigns hunk nav on Octo review buffers — Octo uses ]c/[c for comments
        local is_octo = vim.bo[bufnr].filetype:match("^octo") ~= nil
            or (vim.api.nvim_buf_get_name(bufnr)):match("^octo://") ~= nil

        if not is_octo then
          -- Hunk navigation: bare ]/[ only in diff mode (instant, nowait).
          -- Normal buffers use ]c/[c so other bracket sequences still work.
          local function setup_hunk_maps()
            if vim.wo.diff then
              vim.keymap.set("n", "]", function()
                vim.cmd("normal! ]c")
              end, { buffer = bufnr, nowait = true, desc = "Next change (diff)" })
              vim.keymap.set("n", "[", function()
                vim.cmd("normal! [c")
              end, { buffer = bufnr, nowait = true, desc = "Prev change (diff)" })
            else
              pcall(vim.keymap.del, "n", "]", { buffer = bufnr })
              pcall(vim.keymap.del, "n", "[", { buffer = bufnr })
            end
          end

          -- Re-evaluate when diff mode toggles (OptionSet can't combine pattern+buffer)
          vim.api.nvim_create_autocmd("OptionSet", {
            pattern = "diff",
            callback = function(args)
              if args.buf == bufnr then setup_hunk_maps() end
            end,
          })
          setup_hunk_maps()

          -- ]c/[c for hunk nav on normal (non-diff) buffers
          map("n", "]c", function()
            vim.schedule(function() gs.next_hunk() end)
          end, "Next hunk")
          map("n", "[c", function()
            vim.schedule(function() gs.prev_hunk() end)
          end, "Previous hunk")
        end

        -- Revert hunk (matches <C-g>r)
        map({ "n", "v" }, "<C-g>r", gs.reset_hunk, "Revert hunk")

        -- Preview hunk
        map("n", "<C-g>p", gs.preview_hunk, "Preview hunk")

        -- Blame line (popup)
        map("n", "<C-g>b", function() gs.blame_line({ full = true }) end, "Blame line")

        -- Full file blame (scroll-bound split, --first-parent skips merge noise)
        map("n", "<C-g>B", function()
          gs.blame({ extra_opts = { "--first-parent", "-w", "-C" } })
        end, "Blame file (skip merges)")
      end,
    },
  },

  -- Diffview: full diff UI (GitLens replacement)
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    keys = {
      -- Diff current file against origin/main
      -- Diff current file against merge-base with main (ignores merges from main)
      { "<C-g>d", function()
        local base = vim.fn.systemlist("git merge-base origin/main HEAD")[1]
        if base and base ~= "" then
          vim.cmd("Gvdiffsplit " .. base)
        else
          vim.cmd("Gvdiffsplit origin/main")
        end
      end, desc = "Diff file vs main (ignore merges)" },

      -- Pick commit to diff current file against
      { "<C-g>D", function()
        local dir = vim.fn.expand("%:p:h")
        local git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(dir) .. " rev-parse --show-toplevel 2>/dev/null")[1]
        require("telescope.builtin").git_commits({
          cwd = git_root or dir,
          git_command = { "git", "-C", git_root or dir, "log", "--pretty=format:%h %ar [%an] %s", "--abbrev-commit" },
          attach_mappings = function(_, tmap)
            tmap("i", "<CR>", function(prompt_bufnr)
              local entry = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
              require("telescope.actions").close(prompt_bufnr)
              vim.cmd("Gvdiffsplit " .. entry.value)
            end)
            return true
          end,
        })
      end, desc = "Pick commit to diff file" },

      -- All changed files vs main (full branch diff)
      { "<C-g>M", "<cmd>DiffviewOpen origin/main<cr>", desc = "Diff against origin/main" },

      -- My changes only: diffview scoped to files I touched on this branch.
      -- Shows sidebar with all my changed files, click to see diff vs origin/main.
      { "<C-g>m", function()
        local dir = vim.fn.expand("%:p:h")
        local git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(dir) .. " rev-parse --show-toplevel 2>/dev/null")[1]
        if not git_root or git_root == "" then
          vim.notify("Not in a git repo", vim.log.levels.WARN)
          return
        end
        local email = vim.fn.systemlist("git -C " .. vim.fn.shellescape(git_root) .. " config user.email")[1] or ""
        local files = vim.fn.systemlist(
          "git -C " .. vim.fn.shellescape(git_root)
          .. " log --author=" .. vim.fn.shellescape(email)
          .. " --no-merges --diff-filter=ACMR --name-only --pretty=format: origin/main..HEAD | sort -u | sed '/^$/d'"
        )
        if #files == 0 then
          vim.notify("No files changed by you on this branch", vim.log.levels.INFO)
          return
        end
        local args = { "-C" .. git_root, "origin/main", "--" }
        for _, f in ipairs(files) do
          table.insert(args, f)
        end
        require("diffview").open(args)
      end, desc = "Diff my changes vs main" },

      -- Diff last commit
      -- Three-dot diff: merge-base of origin/main and HEAD vs HEAD.
      -- Shows only changes introduced on this branch, ignoring merges from main.
      { "<C-g>l", "<cmd>DiffviewOpen origin/main...HEAD<cr>", desc = "Diff branch changes vs main" },

      -- Pick commit to diff against via telescope
      { "<C-g>L", function()
        local dir = vim.fn.expand("%:p:h")
        local git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(dir) .. " rev-parse --show-toplevel 2>/dev/null")[1]
        require("telescope.builtin").git_commits({
          cwd = git_root or dir,
          git_command = { "git", "-C", git_root or dir, "log", "--pretty=format:%h %ar [%an] %s", "--abbrev-commit" },
          attach_mappings = function(_, tmap)
            tmap("i", "<CR>", function(prompt_bufnr)
              local entry = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
              require("telescope.actions").close(prompt_bufnr)
              vim.cmd("DiffviewOpen " .. entry.value)
            end)
            return true
          end,
        })
      end, desc = "Pick commit to diff" },

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
    cmd = { "Git", "Gblame", "Gdiffsplit", "Gvdiffsplit", "Gread", "Gwrite" },
  },
}
