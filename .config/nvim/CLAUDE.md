# Neovim Config Context

## Origin
Ported from a heavily customised VSCode + vscodevim setup. All keybindings are intentional overrides from that config — do not "fix" them back to Vim defaults.

## Environment
- **Terminal**: Ghostty (CSI-u enabled, all Ctrl+Shift combos work)
- **Karabiner Elements**: swaps left-ctrl/cmd globally EXCEPT in Ghostty, VSCode, and Terminal
- **Theme**: Synthwave '84 (`lunarvim/synthwave84.nvim`)
- **Plugin manager**: lazy.nvim (auto-bootstrap)
- **Neovim**: 0.12+ (built-in treesitter, EditorConfig)

## Key Design Decisions

### Space is NOT leader
`<Space>` is mapped to format document (normal) and format selection (visual) via conform.nvim. Leader remains `\` (Neovim default). Do not remap Space to leader.

### Intentional Vim override mappings
These override built-in Vim motions — the user is aware and has used them this way in VSCode:
- `t`/`T` → `gt`/`gT` (tab nav, overrides till-char)
- `R` → LSP rename (overrides Replace mode)
- `J` → `gJ` join without spaces (overrides normal join)
- `k`/`j` → `gk`/`gj` with count guard (display-line movement)
- `$`/`^` → `g$`/`g^` (wrapped line ends)
- `}`/`{` → next/prev diagnostic (overrides paragraph motion)

### Git prefix: Ctrl+g
All git operations use `<C-g>` as a prefix:
- `<C-g>d` — diff with previous
- `<C-g>D` — file history (current file)
- `<C-g>L` — all changed files
- `<C-g>l` — repo file history
- `<C-g>r` — revert hunk
- `<C-g>i` — toggle diffview
- `<C-g>p` — preview hunk
- `<C-g>b` — blame line

### Hunk navigation
Bare `]`/`[` for git hunks (gitsigns). Shadows native `[[`, `[{`, `[m`, etc. with a timeoutlen delay before the bare key fires — accepted tradeoff.

### Surround keymaps
Custom nvim-surround bindings: `sa` (add), `sr` (change), `sd` (delete).

## Plugin Stack
| Plugin | Purpose |
|---|---|
| nvim-treesitter | Parser installation (highlighting is Neovim built-in) |
| mason + lspconfig | LSP servers: volar, ts_ls, eslint, jsonls |
| nvim-cmp | Completion (Ctrl+Space trigger, Ctrl+j/k navigate) |
| telescope.nvim | Fuzzy finder (Ctrl+p files, Ctrl+Shift+f grep, gz grep) |
| nvim-tree.lua | File explorer (Ctrl+n toggle, Ctrl+Shift+e focus) |
| gitsigns.nvim | Hunk signs, blame, hunk nav |
| diffview.nvim | Full diff UI (GitLens replacement) |
| vim-fugitive | Git commands |
| conform.nvim | Formatting (prettier for TS/Vue/JSON/CSS) |
| nvim-surround | Surround with sa/sr/sd |
| claude-code.nvim | Claude Code CLI in right panel (Ctrl+b) |
| lualine.nvim | Statusline |
| marks.nvim | Marks in sign column |
| synthwave84.nvim | Theme |

## Config Structure
```
~/.config/nvim/
├── init.lua              -- requires options, lazy-setup, keymaps
├── lua/
│   ├── options.lua       -- editor settings
│   ├── keymaps.lua       -- all non-plugin keymaps
│   ├── lazy-setup.lua    -- lazy.nvim bootstrap
│   └── plugins/          -- one file per plugin/group
```

## Gotchas
- nvim-treesitter API changed in latest version: use `require("nvim-treesitter")` not `require("nvim-treesitter.configs")`
- Ghostty config (`~/.config/ghostty/config`) unbinds Ctrl+Shift combos so they pass through to Neovim
- Karabiner config must exclude Ghostty from the ctrl/cmd swap rule (`^com\\.mitchellh\\.ghostty$`)
