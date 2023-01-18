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
	use({
		"folke/noice.nvim",
		config = function()
			require("noice").setup({
					-- add any options here
			})
		end,
		requires = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
			}
	})
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

