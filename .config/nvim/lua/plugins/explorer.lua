return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<C-n>", "<cmd>NvimTreeToggle<cr>", mode = { "n", "v", "i" }, desc = "Toggle file explorer" },
    { "<C-S-e>", "<cmd>NvimTreeFocus<cr>", desc = "Focus file explorer" },
  },
  opts = {
    view = {
      width = 35,
    },
    renderer = {
      icons = {
        show = {
          git = true,
          file = true,
          folder = true,
          folder_arrow = true,
        },
      },
    },
    update_focused_file = {
      enable = true,
    },
    git = {
      enable = true,
    },
  },
}
