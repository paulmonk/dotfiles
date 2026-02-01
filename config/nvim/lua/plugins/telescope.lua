-- Telescope plugins
-- ===

return {
	{
		'nvim-telescope/telescope.nvim',
		cmd = 'Telescope',
		dependencies = {
			'nvim-lua/plenary.nvim',
			{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
		},
		keys = {
			{ '<leader>ff', '<cmd>Telescope find_files<cr>', desc = 'Find Files' },
			{ '<leader>fg', '<cmd>Telescope live_grep<cr>', desc = 'Live Grep' },
			{ '<leader>fb', '<cmd>Telescope buffers<cr>', desc = 'Buffers' },
			{ '<leader>fh', '<cmd>Telescope help_tags<cr>', desc = 'Help Tags' },
			{ '<leader>fr', '<cmd>Telescope oldfiles<cr>', desc = 'Recent Files' },
			{ '<leader>fc', '<cmd>Telescope commands<cr>', desc = 'Commands' },
			{ '<leader>fk', '<cmd>Telescope keymaps<cr>', desc = 'Keymaps' },
			{ '<leader>fH', '<cmd>Telescope highlights<cr>', desc = 'Highlights' },
			{ '<leader>fM', '<cmd>Telescope man_pages<cr>', desc = 'Man Pages' },
			{ '<leader>fR', '<cmd>Telescope registers<cr>', desc = 'Registers' },
			-- Git
			{ '<leader>gc', '<cmd>Telescope git_commits<cr>', desc = 'Git Commits' },
			{
				'<leader>gC',
				'<cmd>Telescope git_bcommits<cr>',
				desc = 'Git Buffer Commits',
			},
			{ '<leader>go', '<cmd>Telescope git_status<cr>', desc = 'Git Status' },
			{
				'<leader>gB',
				'<cmd>Telescope git_branches<cr>',
				desc = 'Git Branches',
			},
		},
		opts = function()
			local actions = require('telescope.actions')
			return {
				defaults = {
					mappings = {
						i = {
							['<C-j>'] = actions.move_selection_next,
							['<C-k>'] = actions.move_selection_previous,
							['<C-n>'] = actions.cycle_history_next,
							['<C-p>'] = actions.cycle_history_prev,
							['<Esc>'] = actions.close,
						},
						n = {
							['<C-j>'] = actions.move_selection_next,
							['<C-k>'] = actions.move_selection_previous,
							['q'] = actions.close,
						},
					},
					file_ignore_patterns = { 'node_modules', '.git/', 'target/' },
					path_display = { 'truncate' },
				},
				pickers = {
					find_files = { hidden = true },
					live_grep = {
						additional_args = function()
							return { '--hidden' }
						end,
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = 'smart_case',
					},
				},
			}
		end,
		config = function(_, opts)
			local telescope = require('telescope')
			telescope.setup(opts)
			telescope.load_extension('fzf')
		end,
	},
}
