-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Clipboard (matches vim.useSystemClipboard)
vim.opt.clipboard = "unnamedplus"

-- Search (matches vim.hlsearch, vim.smartcase, vim.ignorecase)
vim.opt.hlsearch = true
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.incsearch = true

-- UI
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true

-- Keep cursorline visible in unfocused splits so you can see where the cursor is
vim.api.nvim_create_autocmd({ "WinLeave" }, {
  callback = function() vim.wo.cursorline = true end,
})
vim.opt.scrolloff = 8
vim.opt.updatetime = 250

-- Wrapped line movement support
vim.opt.wrap = true
vim.opt.linebreak = true

-- Diff (matches diffEditor.ignoreTrimWhitespace)
vim.opt.diffopt:append("iwhite")

-- Indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- Splits open in natural direction
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Auto-grow focused split vertically (width only), leave height alone
vim.api.nvim_create_autocmd("WinEnter", {
  callback = function()
    if #vim.api.nvim_tabpage_list_wins(0) < 2 then return end
    if vim.api.nvim_win_get_config(0).relative ~= "" then return end
    vim.cmd("vertical resize " .. math.floor(vim.o.columns * 0.65))
  end,
})

-- Disable netrw (nvim-tree replaces it)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Neovide GUI settings
if vim.g.neovide then
  -- Font (use system default; install a Nerd Font and set here for icons)
  vim.o.linespace = 2

  -- Window
  vim.g.neovide_padding_top = 8
  vim.g.neovide_padding_bottom = 8
  vim.g.neovide_padding_left = 8
  vim.g.neovide_padding_right = 8
  vim.g.neovide_opacity = 0.8
  vim.g.neovide_normal_opacity = 0.92
  vim.g.neovide_window_blurred = true

  -- Refresh rate (ProMotion)
  vim.g.neovide_refresh_rate = 120
  vim.g.neovide_refresh_rate_idle = 5

  -- Animations
  vim.g.neovide_scroll_animation_length = 0.1
  vim.g.neovide_cursor_animation_length = 0.12
  vim.g.neovide_cursor_short_animation_length = 0.06
  vim.g.neovide_cursor_trail_size = 2.0
  vim.g.neovide_position_animation_length = 0.08
  vim.g.neovide_cursor_smooth_blink = true
  vim.g.neovide_cursor_animate_in_insert_mode = true

  -- Floating windows
  vim.g.neovide_floating_blur_amount_x = 8.0
  vim.g.neovide_floating_blur_amount_y = 8.0
  vim.g.neovide_floating_shadow = true
  vim.g.neovide_floating_corner_radius = 0.3

  -- macOS
  vim.g.neovide_input_macos_option_key_is_meta = "only_left"

  vim.g.neovide_cursor_vfx_mode = "sonicboom"

  -- Zoom with Ctrl+=/Ctrl+- (Karabiner swaps ctrl/cmd, so physical Ctrl = Cmd in Neovide)
  vim.keymap.set("n", "<C-=>", function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 1.1
  end, { desc = "Zoom in" })
  vim.keymap.set("n", "<C-->", function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor / 1.1
  end, { desc = "Zoom out" })
  vim.keymap.set("n", "<C-0>", function()
    vim.g.neovide_scale_factor = 1.0
  end, { desc = "Reset zoom" })

  -- Misc
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_confirm_quit = true
  vim.g.neovide_remember_window_size = true
end

