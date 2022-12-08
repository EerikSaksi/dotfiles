require('packer').startup(function()
	use 'maxmx03/FluoroMachine.nvim'
	use 'ggandor/leap.nvim'
	use({
			"kwkarlwang/bufjump.nvim",
			config = function()
					require("bufjump").setup({
							forward = "<C-S-i>",
							backward = "<C-S-o>",
							on_success = nil
					})
			end,
	})
	use 'mfussenegger/nvim-dap'
end)

require('leap').add_default_mappings()

local success, fluoromachine = pcall(require, 'fluoromachine')

fluoromachine.setup {
	transparent = true,
	highlights = function(colors, darken, blend)
    local alpha = fluoromachine.config.brightness
    return {
			LineNr = {  fg = colors.purple, bg = fluoromachine:is_transparent(colors.bg) },
    }
  end,

}

vim.cmd 'colorscheme fluoromachine'

local dap = require('dap')

--https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(gdb-via--vscode-cpptools)
dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = '/usr/bin/vscodecpp/debugAdapters/bin/OpenDebugAD7',
}

dap.configurations.rust = {
  {
    name = "Launch file",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopAtEntry = true,
  },
  {
    name = 'Attach to gdbserver :1234',
    type = 'cppdbg',
    request = 'launch',
    MIMode = 'gdb',
    miDebuggerServerAddress = 'localhost:1234',
    miDebuggerPath = '/usr/bin/gdb',
    cwd = '${workspaceFolder}',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
  },
}

vim.cmd "call MapBoth('<silent> <C-n>', ':call <SID>OpenCocExplorer()<CR>')"
