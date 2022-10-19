local success, fluoromachine = pcall(require, 'fluoromachine')

fluoromachine.setup {
	transparent = true
}

vim.cmd 'colorscheme fluoromachine'
