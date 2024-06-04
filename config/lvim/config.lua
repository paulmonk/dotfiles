-- =========================================
-- Useful References:
-- - https://github.com/jimcornmell/lvim
-- =========================================

-- =========================================
-- General
-- =========================================
lvim.colorscheme = "solarized"
lvim.format_on_save = true
lvim.ignore_case = true
lvim.leader = "space"
lvim.log.level = "warn"
lvim.termguicolors = true

-- =========================================
-- keymappings [view all the defaults by pressing <leader>Lk]
-- =========================================
-- Disable arrow movement, resize windows instead.
lvim.keys.normal_mode["<Up>"] = "<cmd>resize +1<CR>"
lvim.keys.normal_mode["<Down>"] = "<cmd>resize -1<CR>"
lvim.keys.normal_mode["<Left>"] = "<cmd>vertical resize +1<CR>"
lvim.keys.normal_mode["<Right>"] = "<cmd>vertical resize -1<CR>"

-- Fast Saving
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.visual_mode["<C-s>"] = ":w<cr>"
lvim.keys.command_mode["<C-s>"] = ":w<cr>"

-- Fast Quit
lvim.keys.normal_mode["Q"] = ":q!<cr>"
lvim.keys.normal_mode["q"] = ":q!<cr>"

-- Toggle fold
lvim.keys.normal_mode["<CR>"] = "za"

-- Double leader key for toggling visual-line mode
lvim.keys.normal_mode["<Leader><Leader>"] = "V"
lvim.keys.visual_mode["<Leader><Leader>"] = "<Esc>"

-- Drag current line/s vertically and auto-indent
lvim.keys.normal_mode["<Leader>k"] = "<cmd>move-2<CR>=="
lvim.keys.normal_mode["<Leader>j"] = "<cmd>move+<CR>=="
lvim.keys.visual_mode["<Leader>k"] = ":move'<-2CR>gv=gv"
lvim.keys.visual_mode["<Leader>j"] = ":move'>+<CR>gv=gv"

-- Duplicate lines without affecting PRIMARY and CLIPBOARD selections.
lvim.keys.normal_mode["<Leader>d"] = "m`\"\"Y\"\"P``"
lvim.keys.visual_mode["<Leader>d"] = "\"\"Y\"\"Pgv"

-- Reselect and re-yank any text that is pasted in visual mode.
-- https://stackoverflow.com/questions/290465/how-to-paste-over-without-overwriting-register
lvim.keys.visual_mode["p"] = "pgvy"
lvim.keys.visual_mode["<expr> p"] = "'pgv\"'.v:register.'y`>'"

-- Start an external command with a single bang
lvim.keys.normal_mode["!"] = ":!>"

-- Keymappings: Navigation
-- ===============
-- Window control
vim.cmd([[
  nnoremap  [Window]   <Nop>
  nmap      s [Window]

  nnoremap [Window]b  <cmd>buffer#<CR>
  nnoremap [Window]c  <cmd>close<CR>
  nnoremap [Window]d  <cmd>bdelete<CR>
  nnoremap [Window]v  <cmd>split<CR>
  nnoremap [Window]g  <cmd>vsplit<CR>
  nnoremap [Window]t  <cmd>tabnew<CR>
  nnoremap [Window]o  <cmd>only<CR>
  nnoremap [Window]q  <cmd>quit<CR>

  " Split current buffer, go to previous window and previous buffer
  nnoremap [Window]sv <cmd>split<CR>:wincmd p<CR>:e#<CR>
  nnoremap [Window]sg <cmd>vsplit<CR>:wincmd p<CR>:e#<CR>
]])

-- Keymappings: Telescope
-- ===============
-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
	-- for input mode
	i = {
		["<C-j>"] = actions.move_selection_next,
		["<C-k>"] = actions.move_selection_previous,
		["<C-n>"] = actions.cycle_history_next,
		["<C-p>"] = actions.cycle_history_prev,
	},
	-- for normal mode
	n = {
		["<C-j>"] = actions.move_selection_next,
		["<C-k>"] = actions.move_selection_previous,
	},
}

-- Keymappings: Which-Key
-- Use which-key to add extra bindings with the leader-key prefix
-- See: https://github.com/LunarVim/LunarVim/blob/rolling/lua/lvim/core/which-key.lua
-- ===============
-- Which-Key | Buffers
-- Append 1-9 keys for buffers navigation (as per bufferline) to existing "Buffers" mapping
for i = 9, 1, -1 do
	lvim.builtin.which_key.mappings["b"][tostring(i)] = {
		string.format("<Cmd>BufferLineGoToBuffer %s<CR>", i),
		string.format("Go to Buffer %s", i)
	}
end
-- Which-Key | Diagnostics
lvim.builtin.which_key.mappings["d"] = {
	name = "Diagnostics",
	d = { "<cmd>TroubleToggle lsp_document_diagnostics<cr>", "document" },
	l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
	q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
	r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
	t = { "<cmd>TroubleToggle<cr>", "trouble" },
	w = { "<cmd>TroubleToggle lsp_workspace_diagnostics<cr>", "workspace" },
}

-- Which-Key | Git
lvim.builtin.which_key.mappings["g"] = {
	name = "Git",
	b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
	c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
	d = {
		"<cmd>Gitsigns diffthis HEAD<cr>",
		"Git Diff",
	},
	j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
	k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
	l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
	o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
	p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
	r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
	s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
	u = {
		"<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
		"Undo Stage Hunk",
	},
	C = {
		"<cmd>Telescope git_bcommits<cr>",
		"Checkout commit(for current file)",
	},
	R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
}
-- Which-Key | Jump
-- TODO: Finish up jump defs.
lvim.builtin.which_key.mappings["j"] = {
	name = "Show/Jump various dev info",
	h = { ":call JumpHelpPage()<CR>", "Jump vim Help page for word under cursor" },
	j = { ":call JumpToSelection()<CR>", "Jump to url or hex color or git etc" },
	m = { ":<C-U>exe 'Man' v:count '<C-R><C-W>'<CR>", "Jump linux Man page for word under cursor" },
	s = { ":call ShowJira()<CR>", "Show jira ticket in new buffer" },
}
-- Which-Key | Search
lvim.builtin.which_key.mappings["s"] = {
	name = "Search",
	b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
	c = { "<cmd>Telescope commands<cr>", "Commands" },
	f = { "<cmd>Telescope find_files<cr>", "Find File" },
	g = { "<cmd>Telescope live_grep<cr>", "Grep" },
	h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
	k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
	p = {
		"<cmd>lua require('telescope.builtin.internal').colorscheme({enable_preview = true})<cr>",
		"Colorscheme with Preview",
	},
	r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
	H = { "<cmd>Telescope highlights<cr>", "Find highlight groups" },
	M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
	R = { "<cmd>Telescope registers<cr>", "Registers" },
}
-- Which-Key | Toggle Display
lvim.builtin.which_key.mappings["t"] = {
	name = "Toggle Display Options",
	c = { ":ColorizerToggle<CR>", "Toggle Hex colour and colour name matches" },
	h = { ":set hlsearch!<CR>", "Toggle Highlight visibility" },
	l = { ":set list!<CR>", "Toggle Whitespace visibility" },
	n = { ":set number!<CR>", "Toggle LineNumbers visibility" },
	s = { ":set spell!<CR>", "Toggle Spell checking" },
	w = { ":set wrap! breakindent! colorcolumn=' .(&colorcolumn == '' ? &textwidth : ''))<CR>", "Toggle line SmartWrap" },
}

-- =========================================
-- Builtins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
-- =========================================
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- Disable floating terminal - using tmux instead
lvim.builtin.terminal.active = false

-- Builtins: Alpha
-- ===============
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.alpha.dashboard.section.header.opts.hl = ""
-- Shorter ASCII art logo, so not too much space is taken up.
lvim.builtin.alpha.dashboard.section.header.val = {
	"▌              ▌ ▌▗",
	"▌  ▌ ▌▛▀▖▝▀▖▙▀▖▚▗▘▄ ▛▚▀▖",
	"▌  ▌ ▌▌ ▌▞▀▌▌  ▝▞ ▐ ▌▐ ▌",
	"▀▀▘▝▀▘▘ ▘▝▀▘▘   ▘ ▀▘▘▝ ▘",
}

-- Builtins: Gitsigns
-- ===============
lvim.builtin.gitsigns.opts.signs.add.text = ''
lvim.builtin.gitsigns.opts.signs.change.text = ''
lvim.builtin.gitsigns.opts.signs.delete.text = ''
lvim.builtin.gitsigns.opts.signs.topdelete.text = ''
lvim.builtin.gitsigns.opts.signs.changedelete.text = ''

-- Builtins: Treesitter
-- ===============
lvim.builtin.treesitter.ensure_installed = {
	"bash",
	"c",
	"css",
	"go",
	"hcl",
	"html",
	"java",
	"javascript",
	"json",
	"lua",
	"make",
	"markdown",
	"python",
	"r",
	"ruby",
	"rust",
	"scala",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"yaml",
}
lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- =========================================
-- LSP settings
-- =========================================

-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = false

-- ---configure a server manually. !!Requires `:LvimCacheReset` to take effect!!
-- ---see the full default list `:lua print(vim.inspect(lvim.lsp.automatic_configuration.skipped_servers))`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. !!Requires `:LvimCacheReset` to take effect!!
-- ---`:LvimInfo` lists which server(s) are skiipped for the current filetype
-- vim.tbl_map(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- LSP: Formatters
-- ===============
-- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{
		command = "black",
	},
	{
		command = "codespell",
	},
	{
		command = "eslint_d",
	},
	{
		command = "gofmt",
	},
	{
		command = "prettierd",
		extra_args = { "--print-with", "100" },
	},
	{
		command = "ruff",
	},
	{
		command = "rustfmt",
	},
	{
		command = "scalafmt",
	},
	{
		command = "shellharden",
	},
	{
		command = "shfmt",
	},
	{
		command = "sqlfluff",
		extra_args = { "--dialect", "postgres –-templater jinja" }
	},
	{
		command = "terraform_fmt",
	},
	{
		command = "tidy",
	},
})

-- LSP: Linters
-- ===============
local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
	{
		command = "alex",
	},
	{
		command = "checkmake",
	},
	{
		command = "chktex",
	},
	{
		command = "codespell",
	},
	{
		command = "dotenv_linter",
	},
	{
		command = "editorconfig_checker",
	},
	{
		command = "eslint_d",
	},
	{
		command = "hadolint",
	},
	{
		command = "mypy",
	},
	{
		command = "proselint",
	},
	{
		command = "revive",
	},
	{
		command = "rubocop",
	},
	{
		command = "ruff",
	},
	{
		command = "selene",
	},
	{
		command = "semgrep",
	},
	{
		command = "shellcheck",
		extra_args = { "--severity", "warning" },
	},
	{
		command = "sqlfluff",
	},
	{
		command = "tfsec",
	},
	{
		command = "tidy",
	},
	{
		command = "tsc",
	},
	{
		command = "vulture",
	},
	{
		command = "zsh",
	},
})

-- LSP: Code Actions
-- ===============
local code_actions = require("lvim.lsp.null-ls.code_actions")
code_actions.setup {
	{
		command = "proselint",
		args = { "--json" },
		filetypes = { "markdown", "tex" },
	},
	{
		command = "refactoring",
	},
	{
		command = "shellcheck",
	},
}

-- =========================================
-- Plugins
-- ============u============================
lvim.plugins = {
	-- Plugin: Colorschemes
	-- ===============
	{
		"folke/lsp-colors.nvim",
		event = "BufRead",
	},
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({ "css", "scss", "html", "javascript" }, {
				RGB = true, -- #RGB hex codes
				RRGGBB = true, -- #RRGGBB hex codes
				RRGGBBAA = true, -- #RRGGBBAA hex codes
				rgb_fn = true, -- CSS rgb() and rgba() functions
				hsl_fn = true, -- CSS hsl() and hsla() functions
				css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
				css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
			})
		end,
	},
	{ "ishan9299/nvim-solarized-lua" },

	-- Plugin: General
	-- ===============
	-- Accelerated J/K
	{
		"xiyaowong/accelerated-jk.nvim",
		commit = "1b3160724383e0180071753f958806859e2bc81a",
		pin = true,
		event = "BufRead",
		config = function()
			require('accelerated-jk').setup {
				-- equal to
				-- nmap <silent> j <cmd>lua require'accelerated-jk'.command('gj')<cr>
				-- nmap <silent> k <cmd>lua require'accelerated-jk'.command('gk')<cr>
				mappings = { j = 'gj', k = 'gk' },
				-- If the interval of key-repeat takes more than `acceleration_limit` ms, the step is reset
				acceleration_limit = 150,
				-- acceleration steps
				acceleration_table = { 7, 12, 17, 21, 24, 26, 28, 30 },
				-- If you want to decelerate a cursor moving by time instead of reset. set it
				-- exampe:
				-- {
				--   { 200, 3 },
				--   { 300, 7 },
				--   { 450, 11 },
				--   { 600, 15 },
				--   { 750, 21 },
				--   { 900, 9999 },
				-- }
				deceleration_table = { { 150, 9999 } },
			}
		end
	},
	-- Enhanced increment/decrement : True, true, January
	{
		"monaqa/dial.nvim",
		event = "BufRead",
		config = function()
			-- keybindings
			vim.cmd([[
				nmap  <C-a>  <Plug>(dial-increment)
				nmap  <C-x>  <Plug>(dial-decrement)
				vmap  <C-a>  <Plug>(dial-increment)
				vmap  <C-x>  <Plug>(dial-decrement)
				vmap g<C-a> g<Plug>(dial-increment)
				vmap g<C-x> g<Plug>(dial-decrement)
			]])
			-- Config
			local augend = require("dial.augend")
			require("dial.config").augends:register_group({
				-- "number#decimal#fixed#zero",
				-- "markup#markdown#header",
				default = {
					augend.integer.alias.decimal_int,
					augend.integer.alias.hex,
					augend.integer.alias.octal,
					augend.integer.alias.binary,
					augend.constant.alias.bool,
					augend.semver.alias.semver,
					augend.date.alias["%Y/%m/%d"],
					augend.date.alias["%Y-%m-%d"],
					augend.date.alias["%H:%M:%S"],
					augend.date.alias["%H:%M"],
					-- lowercase hex colour #1a1a1a
					augend.hexcolor.new {
						case = "lower"
					},
					-- uppercase hex colour #1A1A1A
					-- augend.user.new{
					-- find = require("dial.augend.common").find_pattern("%d+"),
					-- add = function(text, addend, cursor)
					-- local n = tonumber(text)
					-- n = math.floor(n * (2 ^ addend))
					-- text = tostring(n)
					-- cursor = #text
					-- return {text = text, cursor = cursor}
					-- end
					-- },
					augend.constant.new {
						elements = { "Foreground", "Background" },
						word = true, cyclic = true,
					},
					augend.constant.new {
						elements = { "foreground", "background" },
						word = true, cyclic = true,
					},
					augend.constant.new {
						elements = { "&&", "||" },
						word = false, cyclic = true,
					},
					augend.constant.new {
						elements = { "yes", "no" },
						word = false, cyclic = true,
					},
					augend.constant.new {
						elements = { "Yes", "No" },
						word = false, cyclic = true,
					},
					augend.constant.new {
						elements = { "True", "False" },
						word = false, cyclic = true,
					},
					augend.constant.new {
						elements = { "FATAL", "ERROR", "WARN", "INFO", "DEBUG", "TRACE", "OFF" },
						word = false, cyclic = true,
					},
					augend.constant.new {
						elements = { "fatal", "error", "warn", "info", "debug", "trace" },
						word = false, cyclic = true,
					},
					augend.constant.new {
						elements = { "public", "protected", "private" },
						word = false, cyclic = true,
					},
					augend.constant.new {
						elements = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October",
							"November", "December" },
						word = false, cyclic = true,
					},
					augend.constant.new {
						elements = { "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC" },
						word = false, cyclic = true,
					},
					augend.constant.new {
						elements = { "FIX:", "FIXJC:", "FIXME:", "BUG:", "FIXIT:", "ISSUE:", "TODO:", "HACK:", "WARN:", "WARNING:",
							"XXX:", "PERF:", "OPTIM:", "PERFORMANCE:", "OPTIMIZE:", "NOTE:", "INFO:", "TEST:", "OK:", "ISH:", "BAD:" },
						word = false, cyclic = true,
					},
				},
			})
		end
	},
	-- Smooth scrolling
	{
		"karb94/neoscroll.nvim",
		event = "WinScrolled",
		config = function()
			require('neoscroll').setup({
				-- All these keys will be mapped to their corresponding default scrolling animation
				mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>',
					'<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
				hide_cursor = true, -- Hide cursor while scrolling
				stop_eof = true, -- Stop at <EOF> when scrolling downwards
				use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
				respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
				cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
				easing_function = nil, -- Default easing function
				pre_hook = nil, -- Function to run before the scrolling animation starts
				post_hook = nil, -- Function to run after the scrolling animation ends
			})
		end
	},
	-- indentation guides for every line
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufRead",
		config = function()
			require("indent_blankline").setup({
				buftype_exclude = { "terminal" },
				char = "▏",
				filetype_exclude = { "help", "terminal", "dashboard" },
				indentLine_enabled = 1,
				show_end_of_line = true,
				show_first_indent_level = false,
				show_trailing_blankline_indent = false,
				space_char_blankline = " ",
			})
		end
	},
	-- Highlight todo comments
	{
		"folke/todo-comments.nvim",
		event = "BufRead",
		config = function()
			require("todo-comments").setup()
		end,
	},
	-- Look up words and phrases via devdocs.io
	{
		"romainl/vim-devdocs",
		cmd = "DD",
		config = function()
			lvim.keys.normal_mode["gm"] = "<cmd>DD expand('<cword>')<CR>"
		end,
	},
	-- Distraction free writing / coding
	{
		"folke/zen-mode.nvim",
		cmd = { "ZenMode" },
		config = function()
			require("zen-mode").setup({
				window = {
					backdrop = 1,
					height = 1, -- height of the Zen window
					width = 1, -- height of the Zen window
					options = {
						signcolumn = "no", -- disable signcolumn
						number = true, -- disable number column
						relativenumber = false, -- disable relative numbers
						cursorline = true, -- disable cursorline
						cursorcolumn = false, -- disable cursor column
						foldcolumn = "0", -- disable fold column
						list = false, -- disable whitespace characters
					},
				},
				plugins = {
					kitty = {
						enabled = false,
						font = "+5", -- font size increment
					},
					gitsigns = { enabled = false }, -- disables git signs
					tmux = { enabled = false }
				},
			})
		end
	},
	-- EditorConfig Support
	{ "sgur/vim-editorconfig" },
	-- Highlight URL's. http://www.vivaldi.com
	{
		"itchyny/vim-highlighturl",
		event = "BufRead",
	},

	-- Plugin: Git
	-- ===============
	{
		"f-person/git-blame.nvim",
		event = "BufRead",
		cmd = { "GitBlameToggle" },
		init = function()
			vim.cmd("highlight default link gitblame SpecialComment")
			vim.g.gitblame_enabled = 0
		end,
	},
	{
		"tpope/vim-fugitive",
		cmd = {
			"G",
			"Git",
			"Gdiffsplit",
			"Gread",
			"Gwrite",
			"Ggrep",
			"GMove",
			"GDelete",
			"GBrowse",
			"GRemove",
			"GRename",
			"Glgrep",
			"Gedit"
		},
		ft = { "fugitive" }
	},

	-- Plugin: Languages
	-- ===============
  {
	 'PedramNavid/dbtpal',
		ft = { "sql" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
    config = function()
        local dbt = require('dbtpal')
        dbt.setup {
          -- Path to the dbt executable
          path_to_dbt = "dbt",

          -- Path to the dbt project, if blank, will auto-detect
          -- using currently open buffer for all sql,yml, and md files
          path_to_dbt_project = "",

          -- Path to dbt profiles directory
          path_to_dbt_profiles_dir = vim.fn.expand "~/.dbt",

          -- Search for ref/source files in macros and models folders
          extended_path_search = true,

          -- Prevent modifying sql files in target/(compiled|run) folders
          protect_compiled_files = true
        }

        -- Setup key mappings
        vim.keymap.set('n', '<leader>drf', dbt.run)
        vim.keymap.set('n', '<leader>drp', dbt.run_all)
        vim.keymap.set('n', '<leader>dtf', dbt.test)
        vim.keymap.set('n', '<leader>dm', require('dbtpal.telescope').dbt_picker)

        -- Enable Telescope Extension
        require("telescope").load_extension('dbtpal')
		end
	},
	{
		"tpope/vim-git",
		ft = { "gitcommit", "gitrebase", "gitconfig" }
	},
	{
		"towolf/vim-helm",
		ft = { "helm" },
		config = function()
			vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
				pattern = { "*/templates/*.{yaml,yml,tpl}" },
				command = "setfiletype helm",
			})
		end
	},
	{
		"MTDL9/vim-log-highlighting",
		ft = { "log" }
	},
	{
		"hashivim/vim-terraform",
		cmd = {
			"Terraform", "TerraformFmt"
		},
		ft = { "terraform" },
		config = function()
			vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
				pattern = { "*.tf", "*.tfvars" },
				command = "setfiletype terraform",
			})
			vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
				pattern = { "*.hcl" },
				command = "setfiletype hcl",
			})
		end
	},

	-- Plugin: LSP
	-- ===============
	{
		"github/copilot.vim",
		config = function()
			vim.g.copilot_no_tab_map = true
			vim.g.copilot_assume_mapped = true
			vim.g.copilot_tab_fallback = ""
			local cmp = require("cmp")

			lvim.builtin.cmp.mapping["<Tab>"] = function(fallback)
				cmp.mapping.abort()
				local copilot_keys = vim.fn["copilot#Accept"]()
				if copilot_keys ~= "" then
					vim.api.nvim_feedkeys(copilot_keys, "i", true)
				else
					fallback()
				end
			end
		end
	},
	{
		"rmagatti/goto-preview",
		config = function()
			require('goto-preview').setup({
				width = 120; -- Width of the floating window
				height = 25; -- Height of the floating window
				default_mappings = false; -- Bind default mappings
				debug = false; -- Print debug information
				opacity = nil; -- 0-100 opacity level of the floating window where 100 is fully transparent.
				post_open_hook = nil -- A function taking two arguments, a buffer and a window to be ran as a hook.
				-- You can use "default_mappings = true" setup option
				-- Or explicitly set keybindings
				-- vim.cmd("nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>")
				-- vim.cmd("nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>")
				-- vim.cmd("nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>")
			})
		end
	},
	{
		"simrat39/symbols-outline.nvim",
		cmd = { "SymbolsOutline", "SymbolsOutlineOpen" },
	},
	{
		"folke/trouble.nvim",
		cmd = { "Trouble", "TroubleToggle" },
	},

	-- Plugin: Navigation
	-- ===============
	{ "ggandor/leap.nvim", event = "BufRead", },
	{
		'wfxr/minimap.vim',
		build = "cargo install --locked code-minimap",
		cmd = { "Minimap", "MinimapClose", "MinimapToggle", "MinimapRefresh", "MinimapUpdateHighlight" },
		init = function()
			vim.g.minimap_width = 10
			vim.g.minimap_auto_start = 0
			vim.g.minimap_auto_start_win_enter = 0
		end,
	},
	{
		"nacro90/numb.nvim",
		event = "BufRead",
		config = function()
			require("numb").setup({
				show_numbers = true, -- Enable 'number' for the window while peeking
				show_cursorline = true, -- Enable 'cursorline' for the window while peeking
			})
		end,
	},
	{
		"kevinhwang91/nvim-bqf",
		event = { "BufRead", "BufNew" },
		config = function()
			require("bqf").setup({
				auto_enable = true,
				preview = {
					win_height = 12,
					win_vheight = 12,
					delay_syntax = 80,
					border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
				},
				func_map = {
					vsplit = "",
					ptogglemode = "z,",
					stoggleup = "",
				},
				filter = {
					fzf = {
						action_for = { ["ctrl-s"] = "split" },
						extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
					},
				},
			})
		end,
	},
	{
		"windwp/nvim-spectre",
		event = "BufRead",
		config = function()
			require("spectre").setup()
		end,
	},
	{
		"camspiers/snap",
		-- rocks = { 'fzy' },
		config = function()
			local snap = require "snap"
			local layout = snap.get("layout").bottom
			local file = snap.config.file:with { consumer = "fzf", layout = layout }
			local vimgrep = snap.config.vimgrep:with { layout = layout }
			snap.register.command("find_files", file { producer = "ripgrep.file" })
			snap.register.command("buffers", file { producer = "vim.buffer" })
			snap.register.command("oldfiles", file { producer = "vim.oldfile" })
			snap.register.command("live_grep", vimgrep {})
		end,
	},
	{
		"andymass/vim-matchup",
		event = "CursorMoved",
		init = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end,
	},
	{ "christoomey/vim-tmux-navigator" },

	-- Plugin: Treesitter
	-- ===============
	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
}

-- =========================================
-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- =========================================
-- Autocommands: General
-- ===============
-- When editing a file, always jump to the last known cursor position.
-- Credits: https://github.com/farmergreg/vim-lastplace
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		vim.cmd([[
      if index(['gitcommit', 'gitrebase', 'svn', 'hgcommit'], &filetype) == -1 && empty(&buftype) && ! &diff && ! &previewwindow && line("'\"") > 0 && line("'\"") <= line("$")
       if line("w$") == line("$")
         execute "normal! g`\""
       elseif line("$") - line("'\"") > ((line("w$") - line("w0")) / 2) - 1
         execute "normal! g`\"zz"
       else
         execute "normal! \G'\"\<c-e>"
       endif
       if foldclosed('.') != -1
         execute 'normal! zvzz'
       endif
     endif
    ]])
	end,
})

-- Update filetype on save if empty
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*",
	callback = function()
		vim.cmd([[
		 if &l:filetype ==# '' || exists('b:ftdetect')
		   unlet! b:ftdetect
		   filetype detect
		 endif
    ]])
	end,
})

-- Highlight yank
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		vim.cmd([[
      silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=150}
    ]])
	end,
})

-- Automatically set read-only for files being edited elsewhere
vim.api.nvim_create_autocmd("SwapExists", {
	pattern = "*",
	command = "let v:swapchoice = 'o'"
})

-- Update diff comparison once leaving insert mode
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	command = "if &l:diff | diffupdate | endif"
})

-- Equalize window dimensions when resizing vim window
vim.api.nvim_create_autocmd("VimResized", {
	pattern = "*",
	command = "wincmd ="
})

-- Check if file changed when its window is focus, more eager than 'autoread'
vim.api.nvim_create_autocmd("FocusGained", {
	pattern = "*",
	command = "checktime"
})

-- Highlight current line only on focused normal buffer windows
vim.api.nvim_create_autocmd(
	{ "WinEnter", "BufEnter", "InsertLeave" },
	{
		pattern = "*",
		command = "if ! &cursorline && empty(&buftype) | setlocal cursorline | endif"
	}
)
-- Hide cursor line when leaving normal non-diff windows
vim.api.nvim_create_autocmd(
	{ "WinLeave", "BufLeave", "InsertEnter" },
	{
		pattern = "*",
		command = "if &cursorline && ! &diff && empty(&buftype) && ! &pvw && ! pumvisible() | setlocal nocursorline | endif"
	}
)

-- Reload Lunarvim config on save
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "**/lvim/config.lua",
	command = "LvimReload",
})

-- Enable wrap mode for json files only
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.json", "*.jsonc" },
	command = "setlocal wrap",
})

-- Autocommands: Filetypes
-- ===============
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "apache", "html" },
	command = "setlocal path+=./;/",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "crontab",
	command = "setlocal nobackup nowritebackup",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "gitcommit", "qfreplace" },
	command = "setlocal nofoldenable",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "gitcommit",
	command = "setlocal spell",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "helm",
	command = "setlocal expandtab",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	command = "setlocal expandtab spell formatoptions=tcroqn2 comments=n:>",
})


vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	command = "setlocal expandtab tabstop=4",
})

-- Prefer '--' for comments in SQL
vim.api.nvim_create_autocmd("FileType", {
	pattern = "sql",
	command = "setlocal commentstring=--\\ %s",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "terraform",
	command = "setlocal expandtab",
})

-- Let treesitter use bash highlight for zsh files as well
vim.api.nvim_create_autocmd("FileType", {
	pattern = "zsh",
	callback = function()
		require("nvim-treesitter.highlight").attach(0, "bash")
	end,
})

-- =========================================
-- Filetypes
-- =========================================
-- Enable neovim runtime filetype.lua
vim.g.do_filetype_lua = 1
vim.filetype.add({
	filename = {
		['go.sum'] = 'go',
		['Brewfile'] = 'ruby',
		['Tmuxfile'] = 'tmux',
		['yarn.lock'] = 'yaml',
		['.buckconfig'] = 'toml',
		['.flowconfig'] = 'ini',
		['.tern-project'] = 'json',
		['.jsbeautifyrc'] = 'json',
		['.jscsrc'] = 'json',
		['.watchmanconfig'] = 'json',
	},
	pattern = {
		['.*%.js%.map'] = 'json',
		['.*%.postman_collection'] = 'json',
		['Jenkinsfile.*'] = 'groovy',
		['%.kube/config'] = 'yaml',
		['%.config/git/users/.*'] = 'gitconfig',
		['.*/templates/.*%.yaml'] = 'helm',
		['.*/templates/.*%.yml'] = 'helm',
		['.*/templates/.*%.tpl'] = 'helm',
		['.*/playbooks/.*%.yaml'] = 'yaml.ansible',
		['.*/playbooks/.*%.yml'] = 'yaml.ansible',
		['.*/roles/.*%.yaml'] = 'yaml.ansible',
		['.*/roles/.*%.yml'] = 'yaml.ansible',
		['.*/inventory/.*%.ini'] = 'ansible_hosts',
	},
})

-- =========================================
-- Vim config
-- =========================================
vim.cmd("source $XDG_CONFIG_HOME/lvim/general.vim")
