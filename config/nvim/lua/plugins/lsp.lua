-- LSP plugins
-- ===

return {
	-- LSP Configuration
	{
		'neovim/nvim-lspconfig',
		event = { 'BufReadPre', 'BufNewFile' },
		dependencies = {
			'mason.nvim',
			'williamboman/mason-lspconfig.nvim',
		},
		config = function()
			-- Setup keymaps on LSP attach
			vim.api.nvim_create_autocmd('LspAttach', {
				callback = function(args)
					local bufnr = args.buf
					local map = function(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
					end

					map('n', 'gD', vim.lsp.buf.declaration, 'Go to Declaration')
					map('n', 'gd', vim.lsp.buf.definition, 'Go to Definition')
					map('n', 'K', vim.lsp.buf.hover, 'Hover')
					map('n', 'gi', vim.lsp.buf.implementation, 'Go to Implementation')
					map('n', 'gK', vim.lsp.buf.signature_help, 'Signature Help')
					map('n', '<leader>D', vim.lsp.buf.type_definition, 'Type Definition')
					map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')
					map(
						{ 'n', 'v' },
						'<leader>ca',
						vim.lsp.buf.code_action,
						'Code Action'
					)
					map('n', 'gr', vim.lsp.buf.references, 'References')
					map('n', '<leader>f', function()
						vim.lsp.buf.format({ async = true })
					end, 'Format')
				end,
			})
		end,
	},

	-- Mason - Package manager for LSP servers
	{
		'williamboman/mason.nvim',
		cmd = 'Mason',
		build = ':MasonUpdate',
		opts = {
			ensure_installed = {
				'lua-language-server',
				'typescript-language-server',
				'pyright',
				'ruff',
				'gopls',
				'rust-analyzer',
				'terraform-ls',
				'yaml-language-server',
				'json-lsp',
				'bash-language-server',
				'dockerfile-language-server',
				'markdownlint-cli2',
				'biome',
			},
		},
		config = function(_, opts)
			require('mason').setup(opts)
			local mr = require('mason-registry')
			mr:on('package:install:success', function()
				vim.defer_fn(function()
					require('lazy.core.handler.event').trigger({
						event = 'FileType',
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end)
			for _, tool in ipairs(opts.ensure_installed) do
				local p = mr.get_package(tool)
				if not p:is_installed() then
					p:install()
				end
			end
		end,
	},

	-- Mason LSPConfig bridge
	{
		'williamboman/mason-lspconfig.nvim',
		opts = {
			automatic_installation = true,
			handlers = {
				function(server_name)
					require('lspconfig')[server_name].setup({})
				end,
				['lua_ls'] = function()
					require('lspconfig').lua_ls.setup({
						settings = {
							Lua = {
								diagnostics = { globals = { 'vim' } },
								workspace = { checkThirdParty = false },
								telemetry = { enable = false },
							},
						},
					})
				end,
			},
		},
	},

	-- Formatting
	{
		'stevearc/conform.nvim',
		event = { 'BufWritePre' },
		cmd = { 'ConformInfo' },
		keys = {
			{
				'<leader>cf',
				function()
					require('conform').format({ async = true, lsp_fallback = true })
				end,
				desc = 'Format buffer',
			},
		},
		opts = {
			formatters_by_ft = {
				lua = { 'stylua' },
				python = { 'ruff_format' },
				javascript = { 'biome' },
				typescript = { 'biome' },
				javascriptreact = { 'biome' },
				typescriptreact = { 'biome' },
				go = { 'gofmt' },
				rust = { 'rustfmt' },
				sh = { 'shfmt' },
				terraform = { 'terraform_fmt' },
				sql = { 'sqlfluff' },
				markdown = { 'prettier' },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		},
	},

	-- Linting
	{
		'mfussenegger/nvim-lint',
		event = { 'BufReadPre', 'BufNewFile' },
		config = function()
			local lint = require('lint')
			lint.linters_by_ft = {
				python = { 'ruff', 'mypy' },
				javascript = { 'biomejs' },
				typescript = { 'biomejs' },
				go = { 'revive' },
				sh = { 'shellcheck' },
				dockerfile = { 'hadolint' },
				terraform = { 'tfsec' },
				lua = { 'selene' },
				markdown = { 'markdownlint-cli2' },
			}

			vim.api.nvim_create_autocmd(
				{ 'BufWritePost', 'BufReadPost', 'InsertLeave' },
				{
					callback = function()
						lint.try_lint()
					end,
				}
			)
		end,
	},

	-- Diagnostics
	{
		'folke/trouble.nvim',
		cmd = 'Trouble',
		keys = {
			{
				'<leader>xx',
				'<cmd>Trouble diagnostics toggle<cr>',
				desc = 'Diagnostics (Trouble)',
			},
			{
				'<leader>xX',
				'<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
				desc = 'Buffer Diagnostics (Trouble)',
			},
			{
				'<leader>xl',
				'<cmd>Trouble loclist toggle<cr>',
				desc = 'Location List (Trouble)',
			},
			{
				'<leader>xq',
				'<cmd>Trouble qflist toggle<cr>',
				desc = 'Quickfix List (Trouble)',
			},
		},
		opts = {},
	},

	-- Preview definitions
	{
		'rmagatti/goto-preview',
		event = 'LspAttach',
		opts = {
			width = 120,
			height = 25,
			default_mappings = true,
		},
	},

	-- Symbols outline
	{
		'hedyhli/outline.nvim',
		cmd = { 'Outline', 'OutlineOpen' },
		opts = {},
	},
}
