
" General Settings
"---------------------------------------------------------
" General
set mouse=nv                 " Disable mouse in command-line mode
set nomodeline               " Do not use modelines, they are a security risk.
set report=0                 " Don't report on line changes
set errorbells               " Trigger bell on error
set visualbell               " Use visual bell instead of beeping
set signcolumn=yes           " Always show signs column
set hidden                   " hide buffers when abandoned instead of unload
set fileformats=unix,dos,mac " Use Unix as the standard file type
set magic                    " For regular expressions turn magic on
set path=.,**                " Directories to search when using gf
set virtualedit=block        " Position cursor anywhere in visual block
set synmaxcol=1000           " Don't syntax highlight long lines
set formatoptions+=1         " Don't break lines after a one-letter word
set formatoptions-=t         " Don't auto-wrap text
if has('patch-7.3.541')
  set formatoptions+=j       " Remove comment leader when joining lines
endif

if has('vim_starting')
  set encoding=utf-8
  scriptencoding utf-8
endif

" Enables 24-bit RGB color in the TUI
if has('termguicolors')
  set termguicolors
endif

" What to save for views:
set viewoptions-=options
set viewoptions+=slash,unix

" What to save in sessions:
set sessionoptions-=blank
set sessionoptions-=options
set sessionoptions-=globals
set sessionoptions-=folds
set sessionoptions-=help
set sessionoptions-=buffers
set sessionoptions+=tabpages

if has('mac')
  let g:clipboard = {
    \   'name': 'macOS-clipboard',
    \   'copy': {
    \      '+': 'pbcopy',
    \      '*': 'pbcopy',
    \    },
    \   'paste': {
    \      '+': 'pbpaste',
    \      '*': 'pbpaste',
    \   },
    \   'cache_enabled': 0,
    \ }
endif

if has('clipboard')
  set clipboard& clipboard+=unnamedplus
endif

"
" Wildmenu
" --------
if has('wildmenu')
  set nowildmenu
  set wildmode=list:longest,full
  set wildoptions=tagfile
  set wildignorecase
  set wildignore+=.git,.hg,.svn,.stversions,*.spl,*.o,*.out,*~,%*
  set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store
  set wildignore+=**/node_modules/**,**/bower_modules/**,*/.sass-cache/*,.yarn_cache
  set wildignore+=application/vendor/**,**/vendor/ckeditor/**,media/vendor/**
  set wildignore+=*.pyc,__pycache__,*.egg-info,.pytest_cache,.venv,.virtualenv
endif

"
" Vim Directories
" ---------------
set undofile swapfile nobackup
set directory=$DATA_PATH/swap//,$DATA_PATH,~/tmp,/var/tmp,/tmp
set undodir=$DATA_PATH/undo//,$DATA_PATH,~/tmp,/var/tmp,/tmp
set backupdir=$DATA_PATH/backup/,$DATA_PATH,~/tmp,/var/tmp,/tmp
set viewdir=$DATA_PATH/view/
set nospell spellfile=$VIM_PATH/spell/en.utf-8.add

" History saving
set history=1000
if has('nvim')
  "  ShaDa/viminfo:
  "   ' - Maximum number of previously edited files marks
  "   < - Maximum number of lines saved for each register
  "   @ - Maximum number of items in the input-line history to be
  "   s - Maximum size of an item contents in KiB
  "   h - Disable the effect of 'hlsearch' when loading the shada
  set shada='300,<50,@100,s10,h
else
  set viminfo='300,<10,@50,h,n$DATA_PATH/viminfo
endif

" If sudo, disable vim swap/backup/undo/shada/viminfo writing
if $SUDO_USER !=# '' && $USER !=# $SUDO_USER
    \ && $HOME !=# expand('~'.$USER)
    \ && $HOME ==# expand('~'.$SUDO_USER)

  set noswapfile
  set nobackup
  set nowritebackup
  set noundofile
  if has('nvim')
    set shada="NONE"
  else
    set viminfo="NONE"
  endif
endif

" Secure sensitive information, disable backup files in temp directories
if exists('&backupskip')
  set backupskip+=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*
  set backupskip+=.vault.vim
endif

" Disable swap/undo/viminfo/shada files in temp directories or shm
augroup user_secure
  autocmd!
  silent! autocmd BufNewFile,BufReadPre
    \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim
    \ setlocal noswapfile noundofile nobackup nowritebackup viminfo= shada=
augroup END

"
" Tabs and Indents
" ----------------
set textwidth=80    " Text width maximum chars before wrapping
set expandtab       " Expand tabs to spaces.
set tabstop=8       " The number of spaces a tab is
set softtabstop=8   " While performing editing operations
set shiftwidth=2    " Number of spaces to use in auto(indent)
set smarttab        " Tab insert blanks according to 'shiftwidth'
set autoindent      " Use same indenting on new lines
set smartindent     " Smart autoindenting on new lines
set shiftround      " Round indent to multiple of 'shiftwidth'

"
" Timing
" ------
set timeout ttimeout
set timeoutlen=750  " Time out on mappings
set updatetime=400 " Idle time to write swap and trigger CursorHold

" Time out on key codes
set ttimeoutlen=10

"
" Searching
" ---------
set ignorecase      " Search ignoring case
set smartcase       " Keep case when searching with *
set infercase       " Adjust case in insert completion mode
set incsearch       " Incremental search
set hlsearch        " Highlight search results
set wrapscan        " Searches wrap around the end of the file
set showmatch       " Jump to matching bracket
set matchpairs+=<:> " Add HTML brackets to pair matching
set matchtime=1     " Tenths of a second to show the matching paren
set cpoptions-=m    " showmatch will wait 0.5s or until a char is typed
set showfulltag     " Show tag and tidy search in completion

if exists('+inccommand')
  set inccommand=nosplit
endif

if executable('rg')
  set grepformat=%f:%l:%m
  let &grepprg = 'rg --vimgrep' . (&smartcase ? ' --smart-case' : '')
elseif executable('ag')
  set grepformat=%f:%l:%m
  let &grepprg = 'ag --vimgrep' . (&smartcase ? ' --smart-case' : '')
endif

"
" Behavior
" --------
set relativenumber              " Show line numbers relative to position in file
set nowrap                      " No wrap by default
set linebreak                   " Break long lines at 'breakat'
set breakat=\ \ ;:,!?           " Long lines break chars
set nostartofline               " Cursor in same column for few commands
set whichwrap+=h,l,<,>,[,],~    " Move to following line on certain keys
set splitbelow splitright       " Splits open bottom right
set switchbuf=useopen,usetab    " Jump to the first open window in any tab
set switchbuf+=vsplit           " Switch buffer behavior to vsplit
set backspace=indent,eol,start  " Intuitive backspacing in insert mode
set diffopt=filler,iwhite       " Diff mode: show fillers, ignore whitespace
set showfulltag                 " Show tag and tidy search in completion
set complete=.                  " No wins, buffs, tags, include scanning
set completeopt=menuone         " Show menu even for one item
set completeopt+=noselect       " Do not select a match in the menu

if has('patch-7.4.775')
  set completeopt+=noinsert
endif

if has('patch-8.1.0360')
  set diffopt+=internal,algorithm:patience
endif

if exists('+inccommand')
  set inccommand=nosplit
endif

"
" Editor UI Appearance
" --------------------
set noshowmode          " Don't show mode in cmd window
set shortmess=aoOTI     " Shorten messages and don't show intro
set scrolloff=2         " Keep at least 2 lines above/below
set sidescrolloff=5     " Keep at least 5 lines left/right
set number              " Show line numbers
set noruler             " Disable default status ruler
set list                " Show hidden characters
set lazyredraw          " Do not redraw uneccessarily

set showtabline=2       " Always show the tabs line
set winwidth=30         " Minimum width for active window
set winminwidth=10      " Minimum width for inactive window
set winheight=4         " Minimum height for active window
set winminheight=2      " Minimum height for inactive window
set pumheight=15        " Pop-up menu's line height
set helpheight=12       " Minimum help window height
set previewheight=12    " Completion preview height

set noshowcmd           " Don't show command in status line
set cmdheight=2         " Height of the command line
set cmdwinheight=5      " Command-line lines
set noequalalways       " Don't resize windows on split or close
set laststatus=2        " Always show a status line
set colorcolumn=80      " Highlight the 80th character limit
set display=lastline

if has('folding')
  set foldenable
  set foldmethod=syntax
  set foldlevelstart=99
endif

" UI Symbols
" icons:  ▏│ ¦ ╎ ┆ ⋮ ⦙ ┊ 
set showbreak=↪
set listchars=tab:\▏\ ,extends:⟫,precedes:⟪,nbsp:␣,trail:·
"set fillchars=vert:▉,fold:─

" Do not display completion messages
" Patch: https://groups.google.com/forum/#!topic/vim_dev/WeBBjkXE8H8
if has('patch-7.4.314')
  set shortmess+=c
endif

" Do not display message when editing files
if has('patch-7.4.1570')
  set shortmess+=F
endif

" For snippet_complete marker
if has('conceal') && v:version >= 703
  set conceallevel=2 concealcursor=niv
endif

" Enables pseudo-transparency for the popup-menu. Valid values are in
" the range of 0 for fully opaque popupmenu (disabled) to 100 for fully
" transparent background. Values between 0-30 are typically most useful.
if exists('&pumblend')
  set pumblend=20
endif

" Enables pseudo-transparency for floating window
if exists('&winblend')
  set winblend=20
endif
