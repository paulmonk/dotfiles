-- Colorscheme plugins
-- ===

return {
	{
		'ishan9299/nvim-solarized-lua',
		lazy = false,
		priority = 1000,
		config = function()
			vim.opt.termguicolors = true
			vim.opt.background = 'dark'
			vim.g.solarized_visibility = 'high'
			vim.g.solarized_diffmode = 'high'
			vim.cmd.colorscheme('solarized-high')
		end,
	},
	{
		'folke/lsp-colors.nvim',
		event = 'BufRead',
	},
	{
		'norcalli/nvim-colorizer.lua',
		event = 'BufRead',
		opts = {
			filetypes = { 'css', 'scss', 'html', 'javascript' },
			user_default_options = {
				RGB = true,
				RRGGBB = true,
				RRGGBBAA = true,
				rgb_fn = true,
				hsl_fn = true,
				css = true,
				css_fn = true,
			},
		},
	},
}
