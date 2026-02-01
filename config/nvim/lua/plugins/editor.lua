-- Editor enhancement plugins
-- ===

return {
	-- Accelerated J/K
	{
		'xiyaowong/accelerated-jk.nvim',
		event = 'BufRead',
		opts = {
			mappings = { j = 'gj', k = 'gk' },
			acceleration_limit = 150,
			acceleration_table = { 7, 12, 17, 21, 24, 26, 28, 30 },
			deceleration_table = { { 150, 9999 } },
		},
	},

	-- Enhanced increment/decrement
	{
		'monaqa/dial.nvim',
		event = 'BufRead',
		keys = {
			{ '<C-a>', '<Plug>(dial-increment)', mode = { 'n', 'v' } },
			{ '<C-x>', '<Plug>(dial-decrement)', mode = { 'n', 'v' } },
			{ 'g<C-a>', 'g<Plug>(dial-increment)', mode = 'v' },
			{ 'g<C-x>', 'g<Plug>(dial-decrement)', mode = 'v' },
		},
		config = function()
			local augend = require('dial.augend')
			require('dial.config').augends:register_group({
				default = {
					augend.integer.alias.decimal_int,
					augend.integer.alias.hex,
					augend.integer.alias.octal,
					augend.integer.alias.binary,
					augend.constant.alias.bool,
					augend.semver.alias.semver,
					augend.date.alias['%Y/%m/%d'],
					augend.date.alias['%Y-%m-%d'],
					augend.date.alias['%H:%M:%S'],
					augend.date.alias['%H:%M'],
					augend.hexcolor.new({ case = 'lower' }),
					augend.constant.new({
						elements = { 'true', 'false' },
						word = true,
						cyclic = true,
					}),
					augend.constant.new({
						elements = { 'True', 'False' },
						word = true,
						cyclic = true,
					}),
					augend.constant.new({
						elements = { 'yes', 'no' },
						word = false,
						cyclic = true,
					}),
					augend.constant.new({
						elements = { 'Yes', 'No' },
						word = false,
						cyclic = true,
					}),
					augend.constant.new({
						elements = { '&&', '||' },
						word = false,
						cyclic = true,
					}),
					augend.constant.new({
						elements = { 'public', 'protected', 'private' },
						word = false,
						cyclic = true,
					}),
					augend.constant.new({
						elements = { 'FATAL', 'ERROR', 'WARN', 'INFO', 'DEBUG', 'TRACE' },
						word = false,
						cyclic = true,
					}),
				},
			})
		end,
	},

	-- Smooth scrolling
	{
		'karb94/neoscroll.nvim',
		event = 'WinScrolled',
		opts = {
			mappings = {
				'<C-u>',
				'<C-d>',
				'<C-b>',
				'<C-f>',
				'<C-y>',
				'<C-e>',
				'zt',
				'zz',
				'zb',
			},
			hide_cursor = true,
			stop_eof = true,
			respect_scrolloff = false,
			cursor_scrolls_alone = true,
		},
	},

	-- Indentation guides
	{
		'lukas-reineke/indent-blankline.nvim',
		main = 'ibl',
		event = 'BufRead',
		opts = {
			indent = { char = '▏' },
			scope = { enabled = true },
			exclude = {
				filetypes = {
					'help',
					'terminal',
					'dashboard',
					'alpha',
					'lazy',
					'mason',
				},
				buftypes = { 'terminal' },
			},
		},
	},

	-- Highlight todo comments
	{
		'folke/todo-comments.nvim',
		event = 'BufRead',
		dependencies = { 'nvim-lua/plenary.nvim' },
		opts = {},
	},

	-- Zen mode
	{
		'folke/zen-mode.nvim',
		cmd = 'ZenMode',
		opts = {
			window = {
				backdrop = 1,
				height = 1,
				width = 1,
				options = {
					signcolumn = 'no',
					number = true,
					relativenumber = false,
					cursorline = true,
					cursorcolumn = false,
					foldcolumn = '0',
					list = false,
				},
			},
			plugins = {
				gitsigns = { enabled = false },
				tmux = { enabled = false },
			},
		},
	},

	-- EditorConfig support
	{ 'sgur/vim-editorconfig', event = 'BufRead' },

	-- Highlight URLs
	{ 'itchyny/vim-highlighturl', event = 'BufRead' },

	-- Better quickfix
	{
		'kevinhwang91/nvim-bqf',
		ft = 'qf',
		opts = {
			auto_enable = true,
			preview = {
				win_height = 12,
				win_vheight = 12,
				delay_syntax = 80,
				border_chars = {
					'┃',
					'┃',
					'━',
					'━',
					'┏',
					'┓',
					'┗',
					'┛',
					'█',
				},
			},
		},
	},

	-- Search and replace
	{
		'nvim-pack/nvim-spectre',
		cmd = 'Spectre',
		keys = {
			{
				'<leader>sr',
				function()
					require('spectre').open()
				end,
				desc = 'Search and replace',
			},
		},
	},

	-- Match pairs
	{
		'andymass/vim-matchup',
		event = 'BufRead',
		init = function()
			vim.g.matchup_matchparen_offscreen = { method = 'popup' }
		end,
	},

	-- Tmux navigation
	{ 'christoomey/vim-tmux-navigator', lazy = false },

	-- Leap motion
	{
		url = 'https://codeberg.org/andyg/leap.nvim',
		event = 'BufRead',
		config = function()
			require('leap').add_default_mappings()
		end,
	},

	-- Preview line numbers when jumping
	{
		'nacro90/numb.nvim',
		event = 'BufRead',
		opts = {
			show_numbers = true,
			show_cursorline = true,
		},
	},
}
