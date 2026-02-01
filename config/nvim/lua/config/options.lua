-- Neovim Options
-- ===

local opt = vim.opt

-- General
opt.mouse = 'nv' -- Disable mouse in command-line mode
opt.modeline = true -- Automatically setting options from modelines
opt.report = 2 -- Report on line changes
opt.errorbells = true -- Trigger bell on error
opt.visualbell = true -- Use visual bell instead of beeping
opt.hidden = true -- Hide buffers when abandoned instead of unload
opt.fileformats = 'unix,dos,mac' -- Use Unix as the standard file type
opt.magic = true -- For regular expressions turn magic on
opt.path:append('**') -- Directories to search when using gf
opt.isfname:remove('=') -- Remove =, detects filename in var=/foo/bar
opt.virtualedit = 'block' -- Position cursor anywhere in visual block
opt.synmaxcol = 2500 -- Don't syntax highlight long lines
opt.encoding = 'utf-8'
opt.termguicolors = true

-- History and persistence
opt.history = 2000
opt.undofile = true

-- What to save for views and sessions
opt.viewoptions = 'folds,cursor,curdir'
opt.sessionoptions = 'curdir,help,tabpages,winsize'

-- Fast clipboard setup for macOS
if vim.fn.has('mac') == 1 and vim.fn.executable('pbcopy') == 1 then
	vim.g.clipboard = {
		name = 'macOS-clipboard',
		copy = {
			['+'] = 'pbcopy',
			['*'] = 'pbcopy',
		},
		paste = {
			['+'] = 'pbpaste',
			['*'] = 'pbpaste',
		},
		cache_enabled = 0,
	}
end

opt.clipboard:append('unnamedplus')

-- Tabs and Indents
opt.textwidth = 80 -- Text width maximum chars before wrapping
opt.expandtab = false -- Don't expand tabs to spaces
opt.tabstop = 8 -- The number of spaces a tab is
opt.shiftwidth = 2 -- Number of spaces to use in auto(indent)
opt.softtabstop = -1 -- Automatically keeps in sync with shiftwidth
opt.smarttab = true -- Tab insert blanks according to 'shiftwidth'
opt.autoindent = true -- Use same indenting on new lines
opt.smartindent = true -- Smart autoindenting on new lines
opt.shiftround = true -- Round indent to multiple of 'shiftwidth'

-- Timing
opt.timeout = true
opt.ttimeout = true
opt.timeoutlen = 500 -- Time out on mappings
opt.ttimeoutlen = 10 -- Time out on key codes
opt.updatetime = 200 -- Idle time to write swap and trigger CursorHold
opt.redrawtime = 2000 -- Time in milliseconds for stopping display redraw

-- Searching
opt.ignorecase = true -- Search ignoring case
opt.smartcase = true -- Keep case when searching with *
opt.infercase = true -- Adjust case in insert completion mode
opt.incsearch = true -- Incremental search
opt.wrapscan = true -- Searches wrap around the end of the file
opt.inccommand = 'nosplit'

-- Use ripgrep for grep
if vim.fn.executable('rg') == 1 then
	opt.grepformat = '%f:%l:%c:%m'
	opt.grepprg = 'rg --vimgrep --no-heading --smart-case --'
end

-- Formatting
opt.wrap = false -- No wrap by default
opt.linebreak = true -- Break long lines at 'breakat'
opt.breakat = ' \t;:,!?' -- Long lines break chars
opt.startofline = false -- Cursor in same column for few commands
opt.whichwrap:append('h,l,<,>,[,],~')
opt.splitbelow = true
opt.splitright = true
opt.switchbuf = 'uselast'
opt.backspace = 'indent,eol,start'
opt.breakindentopt = 'shift:2,min:20'

opt.formatoptions:append('1') -- Don't break lines after a one-letter word
opt.formatoptions:remove('t') -- Don't auto-wrap text
opt.formatoptions:remove('o') -- Disable comment-continuation
opt.formatoptions:append('j') -- Remove comment leader when joining lines

-- Completion and Diff
opt.complete = '.,w,b,k'
opt.completeopt = 'menu,menuone,noselect'
opt.diffopt:append('iwhite')
opt.diffopt:append('indent-heuristic')
opt.diffopt:append('algorithm:patience')
opt.jumpoptions = 'stack'

-- Wildmenu
opt.wildignorecase = true
opt.wildignore:append({
	'.git',
	'.hg',
	'.svn',
	'.stversions',
	'*.pyc',
	'*.spl',
	'*.o',
	'*.out',
	'*~',
	'%*',
	'*.jpg',
	'*.jpeg',
	'*.png',
	'*.gif',
	'*.zip',
	'**/tmp/**',
	'*.DS_Store',
	'**/node_modules/**',
	'**/bower_modules/**',
	'*/.sass-cache/*',
	'__pycache__',
	'*.egg-info',
	'.pytest_cache',
	'.mypy_cache/**',
})

-- Editor UI
opt.showmode = false -- Don't show mode in cmd window
opt.shortmess:append('aoOTIcF') -- Shorten messages and don't show intro
opt.scrolloff = 999 -- Center cursor with 999
opt.sidescrolloff = 5 -- Keep at least 5 lines left/right
opt.ruler = false -- Disable default status ruler
opt.list = true -- Show hidden characters
opt.relativenumber = true -- Show relative line numbers
opt.number = true -- Show line numbers

opt.showtabline = 2 -- Always show the tabs line
opt.helpheight = 0 -- Disable help window resizing
opt.winwidth = 30 -- Minimum width for active window
opt.winminwidth = 1 -- Minimum width for inactive windows
opt.winheight = 1 -- Minimum height for active window
opt.winminheight = 1 -- Minimum height for inactive window

opt.showcmd = false -- Don't show command in status line
opt.cmdheight = 1 -- Height of the command line
opt.cmdwinheight = 5 -- Command-line lines
opt.equalalways = true -- Resize windows on split or close
opt.laststatus = 2 -- Always show a status line
opt.colorcolumn = '+0' -- Column highlight at textwidth's max character-limit
opt.display = 'lastline'

opt.pumheight = 15 -- Maximum number of items in popup menu
opt.pumwidth = 10 -- Minimum width for the popup menu

-- UI Symbols
opt.showbreak = '↳  '
opt.listchars = {
	tab = '→·',
	trail = '~',
	extends = '⟫',
	precedes = '⟪',
}

-- Folding
opt.foldenable = true
opt.foldmethod = 'indent'
opt.foldlevel = 99

-- Disable backup for certain paths
opt.backupskip:append('/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*')

-- Built-in runtime plugins
vim.g.sh_no_error = 1
vim.g.python_recommended_style = 0
vim.g.vimsyntax_noerror = 1
vim.g.vim_indent_cont = vim.o.shiftwidth
vim.g.ruby_no_expensive = 1
vim.g.PHP_removeCRwhenUnix = 0

-- Custom filetype detection
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
