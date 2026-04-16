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

-- Disable netrw (nvim-tree replaces it)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

