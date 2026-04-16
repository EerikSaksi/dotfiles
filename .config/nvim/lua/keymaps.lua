local map = vim.keymap.set

-- ============================================================================
-- NORMAL MODE
-- ============================================================================

-- Tab navigation: t/T -> gt/gT (overrides till-char, matching VSCode config)
map("n", "t", "gt", { desc = "Next tab" })
map("n", "T", "gT", { desc = "Previous tab" })

-- Display-line movement with count guard (k/j -> gk/gj when no count)
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Wrapped line end/start
map("n", "$", "g$")
map("n", "^", "g^")

-- Join without spaces
map("n", "J", "gJ")

-- Join without spaces
map("n", "<CR>", "i<CR><ESC>")

-- Window navigation with wrap. Try `wincmd {dir}`; if winid unchanged
-- (already at edge), walk to the opposite edge so a single keypress lands
-- on the far side instead of stalling.
local function win_nav(dir, opposite)
  local cur = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. dir)
  if vim.api.nvim_get_current_win() == cur then
    -- At edge — walk opposite direction to the far edge.
    repeat
      local before = vim.api.nvim_get_current_win()
      vim.cmd("wincmd " .. opposite)
    until vim.api.nvim_get_current_win() == before
  end
end

map("n", "<C-j>", function() win_nav("j", "k") end, { desc = "Window down (wrap)" })
map("n", "<C-k>", function() win_nav("k", "j") end, { desc = "Window up (wrap)" })
map("n", "<C-l>", function() win_nav("l", "h") end, { desc = "Window right (wrap)" })
map("n", "<C-h>", function() win_nav("h", "l") end, { desc = "Window left (wrap)" })

-- Format document with Space
map("n", "<Space>", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format document", silent = true })

-- Worktree status: sibling repos with meaningful changes
map("n", "<C-g>s", function() require("worktree-status").open() end, { desc = "Worktree changed repos" })

-- Clear search highlight with Escape
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { silent = true })

-- ============================================================================
-- VISUAL MODE
-- ============================================================================

-- Select full line content
map("v", "V", "^o$", { desc = "Select full line content" })

-- Copy @file#Lstart-end reference to clipboard (Claude Code CLI format)
map("v", "<C-y>", function()
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")
  if start_line > end_line then start_line, end_line = end_line, start_line end
  local filepath = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":~:.")
  local ref
  if start_line == end_line then
    ref = "@" .. filepath .. "#L" .. start_line
  else
    ref = "@" .. filepath .. "#L" .. start_line .. "-" .. end_line
  end
  vim.fn.setreg("+", ref)
  vim.notify("Copied: " .. ref)
  vim.cmd("normal! " .. vim.api.nvim_replace_termcodes("<Esc>", true, false, true))
end, { desc = "Copy Claude @file#L reference" })

-- Paste without yanking replaced text
map("v", "p", '"_dP', { desc = "Paste without yank" })

-- Join without spaces
map("v", "J", "gJ")

-- Format selection with Space
map("v", "<Space>", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format selection", silent = true })

-- Window navigation from visual mode (wrap)
map("v", "<C-j>", function() win_nav("j", "k") end)
map("v", "<C-k>", function() win_nav("k", "j") end)
map("v", "<C-l>", function() win_nav("l", "h") end)
map("v", "<C-h>", function() win_nav("h", "l") end)

-- ============================================================================
-- INSERT MODE
-- ============================================================================

-- Scroll from insert mode
map("i", "<C-u>", "<Esc><C-u>i", { desc = "Scroll up from insert" })
map("i", "<C-d>", "<Esc><C-d>i", { desc = "Scroll down from insert" })

-- Visual block from insert mode
map("i", "<C-v>", "<Esc>v<C-v>", { desc = "Visual block from insert" })

-- Window navigation from insert mode (wrap)
map("i", "<C-j>", function() vim.cmd("stopinsert"); win_nav("j", "k") end, { desc = "Window down from insert" })
map("i", "<C-k>", function() vim.cmd("stopinsert"); win_nav("k", "j") end, { desc = "Window up from insert" })
map("i", "<C-l>", function() vim.cmd("stopinsert"); win_nav("l", "h") end, { desc = "Window right from insert" })
map("i", "<C-h>", function() vim.cmd("stopinsert"); win_nav("h", "l") end, { desc = "Window left from insert" })

-- ============================================================================
-- TERMINAL MODE
-- ============================================================================

-- Window navigation from terminal mode (claude-code panel, :terminal, etc).
-- Exit terminal mode then run the wrapping nav.
map("t", "<C-j>", function() vim.cmd([[stopinsert]]); win_nav("j", "k") end, { desc = "Window down from terminal" })
map("t", "<C-k>", function() vim.cmd([[stopinsert]]); win_nav("k", "j") end, { desc = "Window up from terminal" })
map("t", "<C-l>", function() vim.cmd([[stopinsert]]); win_nav("l", "h") end, { desc = "Window right from terminal" })
map("t", "<C-h>", function() vim.cmd([[stopinsert]]); win_nav("h", "l") end, { desc = "Window left from terminal" })
