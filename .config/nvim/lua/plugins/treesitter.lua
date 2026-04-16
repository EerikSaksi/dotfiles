return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("nvim-treesitter").setup()

    -- Install parsers
    local parsers = {
      "vue", "typescript", "javascript", "html", "css",
      "json", "lua", "python", "markdown", "vimdoc", "yaml", "scss",
    }

    local installed = require("nvim-treesitter.config").get_installed()
    local installed_set = {}
    for _, p in ipairs(installed) do
      installed_set[p] = true
    end

    local to_install = {}
    for _, p in ipairs(parsers) do
      if not installed_set[p] then
        table.insert(to_install, p)
      end
    end

    if #to_install > 0 then
      require("nvim-treesitter.install").install(to_install)
    end

    -- Start treesitter per-buffer on FileType (Neovim 0.12 built-in highlighting).
    -- Plugin-level vim.treesitter.start() fails at load time because buffer 1
    -- has no filetype yet ("language could not be determined").
    -- Reuse installed set to gate start() — get_lang() falls back to the
    -- filetype string itself (e.g. "DiffviewFileHistory"), so checking
    -- get_parser is not enough; start() asserts and throws on unknown langs.
    local installed_lookup = {}
    for _, p in ipairs(require("nvim-treesitter.config").get_installed()) do
      installed_lookup[p] = true
    end
    local function try_start(buf)
      local ft = vim.bo[buf].filetype
      if ft == "" then return end
      local lang = vim.treesitter.language.get_lang(ft)
      if lang and installed_lookup[lang] then
        pcall(vim.treesitter.start, buf, lang)
      end
    end

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args) try_start(args.buf) end,
    })

    -- Catch already-loaded buffers whose FileType fired before this plugin loaded.
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) then
        try_start(buf)
      end
    end
  end,
}
