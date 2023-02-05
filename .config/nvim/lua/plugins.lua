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
	use {
		'pwntester/octo.nvim',
		requires = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope.nvim',
			'kyazdani42/nvim-web-devicons', },
		config = function ()
			require"octo".setup()
		end
	}
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
