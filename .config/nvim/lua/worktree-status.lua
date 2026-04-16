-- Floating window showing sibling repos with meaningful changes (ignoring package-lock.json).
-- "Worktree" = parent directory of current git repo root, containing all sibling repos.

local M = {}

--- Find worktree root: git root of current buffer's repo, then one level up.
--- Falls back to cwd's parent if not inside a git repo (e.g. nvim config dir).
local function get_worktree_root()
  local dir = vim.fn.expand("%:p:h")
  if dir == "" then dir = vim.fn.getcwd() end
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(dir) .. " rev-parse --show-toplevel 2>/dev/null")[1]
  if git_root and git_root ~= "" then
    return vim.fn.fnamemodify(git_root, ":h")
  end
  -- Not in a git repo — use cwd parent as worktree root
  return vim.fn.fnamemodify(vim.fn.getcwd(), ":h")
end

--- Get list of repos with changes (uncommitted OR committed ahead of main),
--- excluding package-lock.json.
--- Returns list of { name, uncommitted, committed, branch } tables.
local function get_changed_repos(worktree_root)
  local results = {}
  -- .git can be a directory (normal repo) or a file (git worktree)
  local entries = vim.fn.readdir(worktree_root, function(name)
    local git_path = worktree_root .. "/" .. name .. "/.git"
    return vim.fn.isdirectory(git_path) == 1 or vim.fn.filereadable(git_path) == 1
  end)

  for _, name in ipairs(entries) do
    local repo_path = vim.fn.shellescape(worktree_root .. "/" .. name)

    -- Uncommitted: unstaged + staged + untracked, excluding package-lock.json
    local uncommitted_cmd = string.format(
      "cd %s && { git diff --name-only; git diff --cached --name-only; git ls-files --others --exclude-standard; } 2>/dev/null | sort -u | grep -v '^package-lock.json$'",
      repo_path
    )
    local uncommitted = vim.fn.systemlist(uncommitted_cmd)
    if #uncommitted == 1 and uncommitted[1] == "" then uncommitted = {} end

    -- Committed ahead of main: files changed in commits on branch, excluding package-lock.json
    local committed_cmd = string.format(
      "cd %s && git diff --name-only main...HEAD 2>/dev/null | sort -u | grep -v '^package-lock.json$'",
      repo_path
    )
    local committed = vim.fn.systemlist(committed_cmd)
    if #committed == 1 and committed[1] == "" then committed = {} end

    -- Branch name
    local branch_cmd = string.format("cd %s && git branch --show-current 2>/dev/null", repo_path)
    local branch = vim.fn.systemlist(branch_cmd)[1] or "unknown"

    if #uncommitted > 0 or #committed > 0 then
      table.insert(results, {
        name = name,
        uncommitted = uncommitted,
        committed = committed,
        branch = branch,
      })
    end
  end

  table.sort(results, function(a, b) return a.name < b.name end)
  return results
end

--- Build display lines from results.
local function build_lines(results)
  if #results == 0 then
    return { "  No repos with meaningful changes." }
  end

  local lines = {}
  for _, repo in ipairs(results) do
    local counts = {}
    if #repo.uncommitted > 0 then table.insert(counts, #repo.uncommitted .. " uncommitted") end
    if #repo.committed > 0 then table.insert(counts, #repo.committed .. " committed") end
    table.insert(lines, "  " .. repo.name .. "  (" .. table.concat(counts, ", ") .. ")")
  end
  return lines
end

function M.open()
  local worktree_root = get_worktree_root()
  if not worktree_root then
    vim.notify("Not inside a git repo", vim.log.levels.WARN)
    return
  end

  local results = get_changed_repos(worktree_root)
  local title = " Changes in " .. vim.fn.fnamemodify(worktree_root, ":t") .. " "
  local lines = build_lines(results)

  -- Floating window dimensions
  local width = math.min(80, math.floor(vim.o.columns * 0.6))
  local height = math.min(#lines + 2, math.floor(vim.o.lines * 0.6))
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = title,
    title_pos = "center",
  })

  -- Close on q or Escape
  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, nowait = true })
  vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf, nowait = true })
end

return M
