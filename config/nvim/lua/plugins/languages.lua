-- Language-specific plugins
-- ===

return {
	-- DBT (data build tool)
	{
		'PedramNavid/dbtpal',
		ft = 'sql',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope.nvim',
		},
		config = function()
			local dbt = require('dbtpal')
			dbt.setup({
				path_to_dbt = 'dbt',
				path_to_dbt_project = '',
				path_to_dbt_profiles_dir = vim.fn.expand('~/.dbt'),
				extended_path_search = true,
				protect_compiled_files = true,
			})

			vim.keymap.set('n', '<leader>drf', dbt.run, { desc = 'DBT run file' })
			vim.keymap.set('n', '<leader>drp', dbt.run_all, { desc = 'DBT run all' })
			vim.keymap.set('n', '<leader>dtf', dbt.test, { desc = 'DBT test' })
			vim.keymap.set(
				'n',
				'<leader>dm',
				require('dbtpal.telescope').dbt_picker,
				{ desc = 'DBT picker' }
			)

			require('telescope').load_extension('dbtpal')
		end,
	},

	-- Git filetypes
	{
		'tpope/vim-git',
		ft = { 'gitcommit', 'gitrebase', 'gitconfig' },
	},

	-- Helm
	{
		'towolf/vim-helm',
		ft = 'helm',
	},

	-- Log highlighting
	{
		'MTDL9/vim-log-highlighting',
		ft = 'log',
	},

	-- Terraform
	{
		'hashivim/vim-terraform',
		ft = { 'terraform', 'hcl' },
		config = function()
			vim.g.terraform_fmt_on_save = 1
		end,
	},

	-- Rust
	{
		'simrat39/rust-tools.nvim',
		ft = 'rust',
		opts = {},
	},

	-- Go
	{
		'ray-x/go.nvim',
		ft = { 'go', 'gomod' },
		dependencies = { 'ray-x/guihua.lua' },
		opts = {},
		build = ':lua require("go.install").update_all_sync()',
	},
}
