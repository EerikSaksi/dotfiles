require('packer').startup(function()
	use 'maxmx03/FluoroMachine.nvim'
end)

local success, fluoromachine = pcall(require, 'fluoromachine')

fluoromachine.setup {
	transparent = true,
	highlights = function(colors, darken, blend)
    local alpha = fluoromachine.config.brightness

    return {
			LineNr = { fg = colors.purple, bg = fluoromachine:is_transparent(colors.bg) },
    }
  end,

}

vim.cmd 'colorscheme fluoromachine'
