-- Tracks files Claude is referencing via PostToolUse hook RPC.
-- <C-g>c opens all tracked files in splits at their referenced lines.
-- Shows explanation popup when focusing a referenced file.

local M = {}

---@type { path: string, line: number|nil, explanation: string|nil }[]
M.refs = {}

-- Track the floating window so we can close it
local popup_win = nil
local popup_buf = nil

local function close_popup()
  if popup_win and vim.api.nvim_win_is_valid(popup_win) then
    vim.api.nvim_win_close(popup_win, true)
  end
  popup_win = nil
  popup_buf = nil
end

local function show_popup(text)
  close_popup()
  if not text or text == "" then return end

  local max_width = math.min(60, math.floor(vim.api.nvim_win_get_width(0) * 0.8))

  -- Wrap text into lines that fit max_width (with padding)
  local lines = {}
  local remaining = text
  while #remaining > 0 do
    if #remaining + 2 <= max_width then
      table.insert(lines, " " .. remaining .. " ")
      break
    end
    -- Find last space within max_width
    local cut = max_width - 2
    local space = remaining:sub(1, cut):find("%s[^%s]*$")
    if not space then space = cut end
    table.insert(lines, " " .. remaining:sub(1, space - 1) .. " ")
    remaining = remaining:sub(space):gsub("^%s+", "")
  end

  popup_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(popup_buf, 0, -1, false, lines)
  vim.bo[popup_buf].bufhidden = "wipe"

  local width = 0
  for _, l in ipairs(lines) do width = math.max(width, #l) end

  popup_win = vim.api.nvim_open_win(popup_buf, false, {
    relative = "win",
    anchor = "NE",
    row = 0,
    col = vim.api.nvim_win_get_width(0),
    width = width,
    height = #lines,
    style = "minimal",
    border = "rounded",
    focusable = false,
  })
end

--- Find explanation for a file path
local function get_explanation(path)
  for _, ref in ipairs(M.refs) do
    if ref.path == path then
      return ref.explanation
    end
  end
  return nil
end

--- Show/hide popup on WinEnter
local function setup_autocmd()
  vim.api.nvim_create_autocmd("WinEnter", {
    group = vim.api.nvim_create_augroup("ClaudeRefsPopup", { clear = true }),
    callback = function()
      close_popup()
      local path = vim.api.nvim_buf_get_name(0)
      local explanation = get_explanation(path)
      if explanation then
        show_popup(explanation)
      end
    end,
  })
  vim.api.nvim_create_autocmd("WinLeave", {
    group = vim.api.nvim_create_augroup("ClaudeRefsPopupClose", { clear = true }),
    callback = close_popup,
  })
end

setup_autocmd()

--- Parse refs file (supports path:line|explanation format)
local function parse_refs_file()
  local refs_file = "/tmp/claude-file-refs.txt"
  if vim.fn.filereadable(refs_file) ~= 1 then return {} end

  local parsed = {}
  for _, entry in ipairs(vim.fn.readfile(refs_file)) do
    if entry ~= "" then
      -- Split on | for explanation
      local main, explanation = entry:match("^(.-)%|(.+)$")
      if not main then main = entry end

      -- Split on : for line number
      local path, lnum = main:match("^(.+):(%d+)$")
      if not path then path = main end

      if vim.fn.filereadable(path) == 1 then
        table.insert(parsed, {
          path = path,
          line = tonumber(lnum),
          explanation = explanation,
        })
      end
    end
  end
  return parsed
end

--- Open all refs in splits, closing current layout
function M.open()
  local refs = M.refs
  -- If no RPC refs, load from file (which may have explanations from /refs)
  if #refs == 0 then
    refs = parse_refs_file()
    -- Store so popups work
    M.refs = refs
  end

  -- Filter to existing files
  local valid = {}
  for _, ref in ipairs(refs) do
    if vim.fn.filereadable(ref.path) == 1 then
      table.insert(valid, ref)
    end
  end

  if #valid == 0 then
    vim.notify("No Claude file refs", vim.log.levels.INFO)
    return
  end

  vim.cmd("only")
  vim.cmd("edit " .. vim.fn.fnameescape(valid[1].path))
  if valid[1].line then
    pcall(vim.api.nvim_win_set_cursor, 0, { valid[1].line, 0 })
    vim.cmd("normal! zz")
  end

  for i = 2, #valid do
    vim.cmd("vsplit " .. vim.fn.fnameescape(valid[i].path))
    if valid[i].line then
      pcall(vim.api.nvim_win_set_cursor, 0, { valid[i].line, 0 })
      vim.cmd("normal! zz")
    end
  end

  vim.cmd("1wincmd w")

  -- Re-trigger treesitter on all opened buffers — first buffer often misses
  -- highlighting because FileType fires before treesitter processes it.
  vim.schedule(function()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.bo[buf].filetype
      local lang = vim.treesitter.language.get_lang(ft)
      if lang then pcall(vim.treesitter.start, buf, lang) end
    end
  end)

  -- Show popup for first file
  local explanation = get_explanation(valid[1].path)
  if explanation then show_popup(explanation) end
end

--- Reload refs from file (after running /refs)
function M.reload()
  M.refs = parse_refs_file()
  vim.notify("Loaded " .. #M.refs .. " Claude refs")
end

--- Clear refs (e.g. between tasks)
function M.clear()
  M.refs = {}
  close_popup()
  vim.notify("Claude refs cleared")
end

return M
