require('packer').startup(function()
	use 'maxmx03/FluoroMachine.nvim'
	use 'ggandor/leap.nvim'
end)

require('leap').add_default_mappings()

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
