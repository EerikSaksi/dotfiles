return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  keys = function()
    -- Resolve git root from current buffer's directory; falls back to cwd.
    local function git_root()
      local dir = vim.fn.expand("%:p:h")
      if dir == "" then return nil end
      local root = vim.fn.systemlist("git -C " .. dir .. " rev-parse --show-toplevel 2>/dev/null")[1]
      if root and root ~= "" then return root end
      return nil
    end

    local function scoped(picker)
      return function()
        local root = git_root()
        require("telescope.builtin")[picker](root and { cwd = root } or {})
      end
    end

    return {
      { "<C-p>", scoped("find_files"), desc = "Find files (git root)" },
      { "<C-S-p>", "<cmd>Telescope commands<cr>", desc = "Command palette" },
      { "<C-S-f>", scoped("live_grep"), desc = "Find in files (git root)" },
      { "gz", scoped("live_grep"), desc = "Find in files (git root, normal)" },
    }
  end,
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        mappings = {
          i = {
            -- Ctrl+j/k to navigate results (matches VSCode quick pick)
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            -- Ctrl+u/d page through results list in chunks
            ["<C-u>"] = actions.results_scrolling_up,
            ["<C-d>"] = actions.results_scrolling_down,
            -- Ctrl+Shift+u/d scroll the preview pane
            ["<C-S-u>"] = actions.preview_scrolling_up,
            ["<C-S-d>"] = actions.preview_scrolling_down,
          },
        },
      },
    })

    telescope.load_extension("fzf")
  end,
}
