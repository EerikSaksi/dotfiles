return {
  -- Synthwave '84 theme
  {
    "lunarvim/synthwave84.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("synthwave84").setup({
        glow = {
          error_msg = true,
          type2 = true,
          func = true,
          keyword = true,
          operator = false,
          buffer_current_target = true,
          buffer_visible_target = true,
          buffer_inactive_target = true,
        },
      })
      vim.cmd.colorscheme("synthwave84")

      -- Diff palette. Synthwave84 default diff colours wash out the changed
      -- text — re-apply after any colorscheme load so :colorscheme toggles
      -- or diffview's own palette resets don't clobber this.
      local function apply_diff_hl()
        local hl = function(group, opts) vim.api.nvim_set_hl(0, group, opts) end

        -- Buffer diffs (vim :diffthis, gitsigns staged preview, diffview)
        hl("DiffAdd",    { bg = "#1d3b2a", fg = "NONE" })         -- added line
        hl("DiffDelete", { bg = "#3d1b24", fg = "#fe4450" })      -- deleted line
        hl("DiffChange", { bg = "#2a2344", fg = "NONE" })         -- changed line (dim)
        hl("DiffText",   { bg = "#5b3a6b", fg = "#ffffff", bold = true }) -- changed word (bright)

        -- Diffview-specific: deletions inside an otherwise-added line, etc.
        hl("DiffviewDiffAddAsDelete", { bg = "#3d1b24", fg = "NONE" })
        hl("DiffviewDiffDelete",      { bg = "NONE",    fg = "#4a3858" }) -- filler lines

        -- Gitsigns signs (left column) — keep existing fg, avoid bg changes
        hl("GitSignsAdd",    { fg = "#72f1b8" })
        hl("GitSignsChange", { fg = "#fede5d" })
        hl("GitSignsDelete", { fg = "#fe4450" })
      end

      apply_diff_hl()
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = apply_diff_hl,
      })
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VimEnter",
    opts = {
      options = {
        theme = "auto",
        section_separators = "",
        component_separators = "",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- Marks in sign column (matches vim.showMarksInGutter)
  {
    "chentoast/marks.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
}
