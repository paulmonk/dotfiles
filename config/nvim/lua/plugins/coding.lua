-- Coding plugins
-- ===

return {
	-- Completion
	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'saadparwaiz1/cmp_luasnip',
			'L3MON4D3/LuaSnip',
		},
		opts = function()
			local cmp = require('cmp')
			local luasnip = require('luasnip')
			return {
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					['<C-n>'] = cmp.mapping.select_next_item({
						behavior = cmp.SelectBehavior.Insert,
					}),
					['<C-p>'] = cmp.mapping.select_prev_item({
						behavior = cmp.SelectBehavior.Insert,
					}),
					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>'] = cmp.mapping.abort(),
					['<CR>'] = cmp.mapping.confirm({ select = true }),
					['<Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { 'i', 's' }),
					['<S-Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { 'i', 's' }),
				}),
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
					{ name = 'path' },
				}, {
					{ name = 'buffer' },
				}),
			}
		end,
	},

	-- Snippets
	{
		'L3MON4D3/LuaSnip',
		build = 'make install_jsregexp',
		dependencies = {
			'rafamadriz/friendly-snippets',
			config = function()
				require('luasnip.loaders.from_vscode').lazy_load()
			end,
		},
		opts = {
			history = true,
			delete_check_events = 'TextChanged',
		},
	},

	-- Auto pairs
	{
		'windwp/nvim-autopairs',
		event = 'InsertEnter',
		opts = {
			check_ts = true,
		},
		config = function(_, opts)
			require('nvim-autopairs').setup(opts)
			local cmp_autopairs = require('nvim-autopairs.completion.cmp')
			require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())
		end,
	},

	-- Comments
	{
		'numToStr/Comment.nvim',
		event = { 'BufReadPost', 'BufNewFile' },
		opts = {},
	},

	-- Surround
	{
		'kylechui/nvim-surround',
		event = { 'BufReadPost', 'BufNewFile' },
		opts = {},
	},

	-- GitHub Copilot
	{
		'github/copilot.vim',
		event = 'InsertEnter',
		config = function()
			vim.g.copilot_no_tab_map = true
			vim.g.copilot_assume_mapped = true
			vim.keymap.set(
				'i',
				'<C-J>',
				'copilot#Accept("\\<CR>")',
				{ expr = true, replace_keycodes = false }
			)
		end,
	},

	-- Claude Code
	{
		'coder/claudecode.nvim',
		dependencies = { 'folke/snacks.nvim' },
		lazy = false,
		config = true,
		opts = {
			terminal = {
				split_side = 'right',
				split_width_percentage = 0.40,
			},
		},
	},
}
