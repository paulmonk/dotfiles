" Neovim settings
" ===

" General {{{
set mouse=nv                 " Disable mouse in command-line mode
set modeline                 " automatically setting options from modelines
set report=2                 " Report on line changes
set errorbells               " Trigger bell on error
set visualbell               " Use visual bell instead of beeping
set hidden                   " hide buffers when abandoned instead of unload
set fileformats=unix,dos,mac " Use Unix as the standard file type
set magic                    " For regular expressions turn magic on
set path+=**                 " Directories to search when using gf and friends
set isfname-==               " Remove =, detects filename in var=/foo/bar
set virtualedit=block        " Position cursor anywhere in visual block
set synmaxcol=2500           " Don't syntax highlight long lines

if has('vim_starting')
	set encoding=utf-8
	scriptencoding utf-8
endif

" History and persistence
set history=2000

" What to save for views and sessions
set viewoptions=folds,cursor,curdir
set sessionoptions=curdir,help,tabpages,winsize

" Fast clipboard setup for macOS
if has('mac') && executable('pbcopy') && has('vim_starting')
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

if has('clipboard') && has('vim_starting')
	" set clipboard& clipboard+=unnamedplus
	set clipboard& clipboard^=unnamed,unnamedplus
endif

" }}}
" Vim Directories {{{
" ---------------
set undofile

augroup user_persistent_undo
	autocmd!
	au BufWritePre /tmp/*          setlocal noundofile
	au BufWritePre *.tmp           setlocal noundofile
	au BufWritePre *.bak           setlocal noundofile
	au BufWritePre COMMIT_EDITMSG  setlocal noundofile noswapfile
	au BufWritePre MERGE_MSG       setlocal noundofile noswapfile
augroup END

" If sudo, disable vim swap/backup/undo/shada/viminfo writing
if $SUDO_USER !=# '' && $USER !=# $SUDO_USER
		\ && $HOME !=# expand('~' . $USER, 1)
		\ && $HOME ==# expand('~' . $SUDO_USER, 1)

	set nomodeline
	set noswapfile
	set nobackup
	set nowritebackup
	set noundofile
	if has('nvim')
		set shadafile=NONE
	else
		set viminfofile=NONE
	endif
endif

" Secure sensitive information, disable backup files in temp directories
if exists('&backupskip')
	set backupskip+=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*
endif

" Disable swap/undo/viminfo files in temp directories or shm
augroup user_secure
	autocmd!
	silent! autocmd BufNewFile,BufReadPre
		\ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim
		\ setlocal noswapfile noundofile
		\ | set nobackup nowritebackup
		\ | if has('nvim') | set shada= | else | set viminfo= | endif
augroup END

" }}}
" Tabs and Indents {{{
" ----------------
set textwidth=80    " Text width maximum chars before wrapping
set noexpandtab     " Don't expand tabs to spaces
set tabstop=8       " The number of spaces a tab is
set shiftwidth=2    " Number of spaces to use in auto(indent)
set softtabstop=-1  " Automatically keeps in sync with shiftwidth
set smarttab        " Tab insert blanks according to 'shiftwidth'
set autoindent      " Use same indenting on new lines
set smartindent     " Smart autoindenting on new lines
set shiftround      " Round indent to multiple of 'shiftwidth'

" }}}

" Timing {{{
" ------
set timeout ttimeout
set timeoutlen=500   " Time out on mappings
set ttimeoutlen=10   " Time out on key codes
set updatetime=200   " Idle time to write swap and trigger CursorHold
set redrawtime=2000  " Time in milliseconds for stopping display redraw

" }}}
" Searching {{{
" ---------
set ignorecase    " Search ignoring case
set smartcase     " Keep case when searching with *
set infercase     " Adjust case in insert completion mode
set incsearch     " Incremental search
set wrapscan      " Searches wrap around the end of the file

if exists('+inccommand')
	set inccommand=nosplit
endif

if executable('rg')
	set grepformat=%f:%l:%c:%m
	let &grepprg =
		\ 'rg --vimgrep --no-heading' . (&smartcase ? ' --smart-case' : '') . ' --'
elseif executable('ag')
	set grepformat=%f:%l:%c:%m
	let &grepprg =
		\ 'ag --vimgrep' . (&smartcase ? ' --smart-case' : '') . ' --'
endif

" }}}
" Formatting {{{
" --------
set nowrap                      " No wrap by default
set linebreak                   " Break long lines at 'breakat'
set breakat=\ \	;:,!?           " Long lines break chars
set nostartofline               " Cursor in same column for few commands
set whichwrap+=h,l,<,>,[,],~    " Move to following line on certain keys
set splitbelow splitright       " Splits open bottom right
set switchbuf=uselast           " Use last window with quickfix entries
set backspace=indent,eol,start  " Intuitive backspacing in insert mode

if exists('&breakindent')
	set breakindentopt=shift:2,min:20
endif

set formatoptions+=1         " Don't break lines after a one-letter word
set formatoptions-=t         " Don't auto-wrap text
set formatoptions-=o         " Disable comment-continuation (normal 'o'/'O')
set formatoptions+=j         " Remove comment leader when joining lines

" }}}
" Completion and Diff {{{
" --------
set complete=.,w,b,k  " C-n completion: Scan buffers, windows and dictionary
set completeopt=menu,menuone  " Always show menu, even for one item
set completeopt+=noselect     " Do not select a match in the menu.

set diffopt+=iwhite           " Diff mode: ignore whitespace
set diffopt+=indent-heuristic,algorithm:patience

" Use the new Neovim :h jumplist-stack
set jumpoptions=stack

" Command-line completion
if has('wildmenu')
	set wildignorecase
	set wildignore+=.git,.hg,.svn,.stversions,*.pyc,*.spl,*.o,*.out,*~,%*
	set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store
	set wildignore+=**/node_modules/**,**/bower_modules/**,*/.sass-cache/*
	set wildignore+=__pycache__,*.egg-info,.pytest_cache,.mypy_cache/**
endif

" }}}

" Editor UI {{{
" --------------------
set noshowmode          " Don't show mode in cmd window
set shortmess=aoOTI     " Shorten messages and don't show intro
set scrolloff=999       " Center cursor with 999
set sidescrolloff=5     " Keep at least 5 lines left/right
set noruler             " Disable default status ruler
set list                " Show hidden characters
set relativenumber      " Show relative line numbers

set showtabline=2       " Always show the tabs line
set helpheight=0        " Disable help window resizing
set winwidth=30         " Minimum width for active window
set winminwidth=1       " Minimum width for inactive windows
set winheight=1         " Minimum height for active window
set winminheight=1      " Minimum height for inactive window

set noshowcmd           " Don't show command in status line
set cmdheight=1         " Height of the command line
set cmdwinheight=5      " Command-line lines
set equalalways         " Resize windows on split or close
set laststatus=2        " Always show a status line
set colorcolumn=+0      " Column highlight at textwidth's max character-limit
set display=lastline

" Set popup max width/height.
set pumheight=15        " Maximum number of items to show in the popup menu
if exists('+pumwidth')
	set pumwidth=10       " Minimum width for the popup menu
endif

" UI Symbols
" icons:  ▏│ ¦ ╎ ┆ ⋮ ⦙ ┊ 
let &showbreak='↳  '
set listchars=tab:\→\·,trail:~,extends:⟫,precedes:⟪

if has('folding') && has('vim_starting')
	set foldenable
	set foldmethod=indent
	set foldlevel=99
endif

" Do not display completion messages
set shortmess+=c

" Do not display message when editing files
set shortmess+=F

" Built-in runtime plugins {{{
let g:sh_no_error = 1
let g:python_recommended_style = 0
let g:vimsyntax_noerror = 1
let g:vim_indent_cont = &shiftwidth
let g:ruby_no_expensive = 1
let g:PHP_removeCRwhenUnix = 0

" }}}
" Abbreviations {{{

" Misc
iab what what
iab Vari Variables
iab the the
iab tehn then
iab Req Request
iab fb foobar
iab Attr Attributes
iab Appl Application
iab and and

" }}}
" Mappings {{{
" C-r: Easier search and replace visual/select mode
xnoremap <C-r> :<C-u>%s/\V<C-R>=<SID>get_selection()<CR>//gc<Left><Left><Left>
"
" }}}
" Functions {{{
" --------------------
" Jump, looks under the cursor for a URL, Hex Code, GithubProject or Word!
function! JumpToSelection()
  let url=matchstr(expand("<cWORD>"), 'http[s]*:\/\/[^ >,;)]*')
  " let url=matchstr(expand("<cWORD>"), 'https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?\S*/')
  " let url=matchstr(expand("<cWORD>"), 'https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?\S*/')

  " Is it a url?
  if url != ""
      silent exec ":!xdg-open '".url."'" | redraw!
      echo "Opening URL ".url
  else
      let wordUnderCursor = expand("<cWORD>")
      let hexcode = matchstr(wordUnderCursor, '[0-9a-fA-F]\{6}')

      " Is it a hex colour code?
      if hexcode != ""
          let url="https://www.colorhexa.com/" . hexcode
          silent exec ':!xdg-open "'.url.'"' | redraw!
          echo "Opened HEX colour ".url
					return
			endif

			let projectPath = matchstr(wordUnderCursor, '[0-9a-zA-Z-]\{3,}/[0-9a-z-A-Z\.]\{3,}')

			" Is it a GitHub project?
			if projectPath != ""
					let url="https://github.com/" . projectPath
					silent exec ':!xdg-open "'.url.'"' | redraw!
					echo "Opened GitHub project : ".projectPath
					return
			endif

			" Is it a Jira ticket number project?
			let jiraTicket = matchstr(wordUnderCursor, '[a-zA-Z]\{2,4}-[0-9]\{1,7}')
			if jiraTicket != ""
					exec ':!$HOME/bin/Jira open '.jiraTicket
					return
			endif

			" Cheat for keyword
			let url='https://cheat.sh/' . &filetype . '/' . wordUnderCursor
			if url != ""
					let $CURLCMDVIM='https://cheat.sh/' . &filetype . '/' . wordUnderCursor
					term curl -s $CURLCMDVIM
					echo "Opened Cheat ".url
					return
			endif

			" Fallback
			echo "No URL, HEX colour sequence, GitHub Project or Keyword under cursor."
			return
		endif
endfunction

" Jump to Vim Help page for word under cursor
function! JumpHelpPage()
  let s:help_word = expand('<cword>')
  :exe ":help " . s:help_word
endfunction

" Use Jira command line tool to show info for current ticket (if under cursor)
" or branch for current project file is in.
function! ShowJira()
    let wordUnderCursor = expand("<cWORD>")
    let jiraTicket = matchstr(wordUnderCursor, '[a-zA-Z]\{2,4}-[0-9]\{1,7}')

    if jiraTicket != ""
        let $TICKET=jiraTicket
        term jira view $TICKET
    endif
endfunction

" Delete whitespace at end of lines, and put cursor back to where it started.
function! DeleteEndingWhiteSpace()
    let current_position=getpos(".")
    let reg=@/
    %s/\s*$//
    let @/=reg
    unlet reg
    call setpos('.', current_position)
    unlet current_position
endfunction

" Returns visually selected text
function! s:get_selection() abort "{{{
	try
		let reg = 's'
		let [save_reg, save_type] = [getreg(reg), getregtype(reg)]
		silent! normal! gv"sy
		return substitute(escape(@s, '\/'), '\n', '\\n', 'g')
	finally
		call setreg(reg, save_reg, save_type)
	endtry
endfunction "}}}

" }}}
