" ---------------------------------------------------------
" Core
" ---------------------------------------------------------
set nomodeline              " Do not use modelines, they are a security risk.

set expandtab               " Expand tabs to spaces.
set tabstop=8               " The number of spaces a tab is
set softtabstop=8           " While performing editing operations
set smartindent             " Smart autoindenting on new lines

set number                  " Show line numbers


" ---------------------------------------------------------
" Filetype
" ---------------------------------------------------------
" https://webpack.js.org/guides/development/#adjusting-your-text-editor
autocmd FileType css,javascript,javascriptreact,typescript,typescriptreact setlocal backupcopy=yes

" ---------------------------------------------------------
" Theme
" ---------------------------------------------------------
" Enable 256 color terminal
set t_Co=256

" GUI
if has('gui_running')
  set lines=40
  set columns=150
endif

" COLORSCHEME
set background=dark
colorscheme solarized8

" UI elements
set showbreak=↪
set fillchars=vert:│,fold:─
set listchars=tab:\—\ ,extends:⟫,precedes:⟪,nbsp:␣,trail:·


" Highlights: General GUI
" --------------------------------
highlight! link pythonSpaceError  NONE
highlight! link pythonIndentError NONE
highlight! link ExtraWhitespace  SpellBad
highlight! WarningMsg ctermfg=100 guifg=#CCC566

highlight ParenMatch  ctermbg=236 guibg=#30302c
highlight CursorWord0 ctermbg=236 guibg=#30302c
highlight CursorWord1 ctermbg=236 guibg=#30302c


" Plugin: denite
" --------------------------------
highlight! clear WildMenu
highlight! link WildMenu CursorLine
highlight! link deniteSelectedLine Type
highlight! link deniteMatchedChar Function
highlight! link deniteMatchedRange Underlined
highlight! link deniteMode Comment
highlight! link deniteSource_QuickfixPosition qfLineNr


" Plugin: vim-signatures
" --------------------------------
highlight! SignatureMarkText    ctermfg=11 guifg=#756207 ctermbg=234 guibg=#1c1c1c
highlight! SignatureMarkerText  ctermfg=12 guifg=#4EA9D7 ctermbg=234 guibg=#1c1c1c


" Plugin: vim-gitgutter
" --------------------------------
highlight! GitGutterAdd ctermfg=22 guifg=#006000 ctermbg=NONE guibg=NONE
highlight! GitGutterChange ctermfg=58 guifg=#5F6000 ctermbg=NONE guibg=NONE
highlight! GitGutterDelete ctermfg=52 guifg=#600000 ctermbg=NONE guibg=NONE
highlight! GitGutterChangeDelete ctermfg=52 guifg=#600000 ctermbg=NONE guibg=NONE


" Plugin: vim-operator-flashy
" --------------------------------
highlight! link Flashy DiffText


" Plugin: vim-bookmarks
" --------------------------------
let g:bookmark_sign = '⚐'
highlight! BookmarkSign            ctermfg=12 guifg=#4EA9D7
highlight! BookmarkAnnotationSign  ctermfg=11 guifg=#EACF49
" }}}


" Plugin: vim-choosewin
" ---------------------------------------------------------
let g:choosewin_label = 'SDFJKLZXCV'
let g:choosewin_overlay_enable = 1
let g:choosewin_statusline_replace = 1
let g:choosewin_overlay_clear_multibyte = 0
let g:choosewin_blink_on_land = 0

let g:choosewin_color_label = {
	\ 'cterm': [ 236, 2 ], 'gui': [ '#555555', '#000000' ] }
let g:choosewin_color_label_current = {
	\ 'cterm': [ 234, 220 ], 'gui': [ '#333333', '#000000' ] }
let g:choosewin_color_other = {
	\ 'cterm': [ 235, 235 ], 'gui': [ '#333333' ] }
let g:choosewin_color_overlay = {
	\ 'cterm': [ 2, 10 ], 'gui': [ '#88A2A4' ] }
let g:choosewin_color_overlay_current = {
	\ 'cterm': [ 72, 64 ], 'gui': [ '#7BB292' ] }

" Plugin: Defx icons and highlights
" ---------------------------------------------------------
let g:defx_git#indicators = {
	\ 'Modified'  : '•',
	\ 'Staged'    : '✚',
	\ 'Untracked' : 'ᵁ',
	\ 'Renamed'   : '≫',
	\ 'Unmerged'  : '≠',
	\ 'Ignored'   : 'ⁱ',
	\ 'Deleted'   : '✖',
	\ 'Unknown'   : '⁇'
	\ }

highlight Defx_filename_3_Modified  ctermfg=1  guifg=#D370A3
highlight Defx_filename_3_Staged    ctermfg=10 guifg=#A3D572
highlight Defx_filename_3_Ignored   ctermfg=8  guifg=#404660
highlight def link Defx_filename_3_Untracked Comment
highlight def link Defx_filename_3_Unknown Comment
highlight def link Defx_filename_3_Renamed Title
highlight def link Defx_filename_3_Unmerged Label
" highlight Defx_git_Deleted   ctermfg=13 guifg=#b294bb


" ---------------------------------------------------------
" Plugins
" ---------------------------------------------------------
" Ale: Core
" --------------------------------
let g:ale_sign_error = '⚠'
let g:ale_sign_warning = '⌁'
let g:ale_sign_info = '⊹'


" Ale: History
" ------------------------------
" Enable history
let g:ale_history_enabled = 1

" Ale will store output of commands which have completed succesfully.
let g:ale_history_log_output = 1

" How much history of commands to save.
let g:ale_max_buffer_history_size = 20

" Use global executables by default
let g:ale_use_global_executables = 1


" Ale: Linter
" ------------------------------
" Whether lint on opening of a file
let g:ale_lint_on_enter = 0

" Whether to only enable the linters specified.
let g:ale_linters_explicit = 1

" Set the ale linters to use for specifc filetypes.
let g:ale_linters = {
\   'css': ['stylelint'],
\   'dockerfile': ['hadolint'],
\   'fish': ['fish'],
\   'graphql': ['eslint'],
\   'javascript': ['eslint'],
\   'javascriptreact': ['eslint'],
\   'json': ['jsonlint'],
\   'help': ['proselint', 'alex'],
\   'html': ['proselint', 'tidy', 'alex'],
\   'mail': ['proselint'],
\   'markdown': ['proselint', 'alex'],
\   'python': ['bandit', 'flake8', 'mypy', 'pylint'],
\   'sh': ['shellcheck'],
\   'sql': ['sqlint'],
\   'typescript': ['eslint', 'tsserver'],
\   'typescriptreact': ['eslint', 'tsserver'],
\   'vim': ['vint'],
\   'yaml': ['yamllint']
\}

" Linter aliases
let g:ale_linter_aliases = {
\   'bash': ['sh'],
\   'csh': ['sh'],
\   'htmldjango': ['html'],
\   'javascriptreact': ['javascript'],
\   'typescriptreact': ['typescript'],
\   'zsh': ['sh']
\}


" Ale: Fixer
" ------------------------------
" Set this setting in vimrc if you want to fix files automatically on save.
" This is off by default.
let g:ale_fix_on_save = 0

" Set the ale fixers for specfic filetypes
let g:ale_fixers = {
\   'css': ['prettier'],
\   'go': ['gofmt'],
\   'graphql': ['prettier'],
\   'javascript': ['prettier'],
\   'javascriptreact': ['prettier'],
\   'json': ['prettier'],
\   'markdown': ['prettier'],
\   'python': ['isort', 'black'],
\   'scss': ['prettier'],
\   'sh': ['shfmt'],
\   'sql': ['sqlformat'],
\   'typescript': ['prettier'],
\   'typescriptreact': ['prettier'],
\   'yaml': ['prettier']
\}

" Do not lint or fix minified files.
let g:ale_pattern_options = {
\   '\.min\.css$': {'ale_linters': [], 'ale_fixers': []},
\   '\.min\.js$': {'ale_linters': [], 'ale_fixers': []},
\   '\.min\.ts$': {'ale_linters': [], 'ale_fixers': []},
\}
" If you configure g:ale_pattern_options outside of vimrc, you need this.
let g:ale_pattern_options_enabled = 1


" Ale: Format Specifc
" ------------------------------
" Dockerfile
" If not installed locally, should we use the docker image available.
" options: 'never', 'always', 'maybe'.
" If 'maybe' then checks locally first and uses docker image as fallback.
let g:ale_dockerfile_hadolint_use_docker = 'maybe'

" GraphQL
let g:ale_graphql_prettier_options = '--parser graphql'

" Javascript
let g:ale_javascript_prettier_options = '--single-quote'
let g:ale_javascriptreact_prettier_options = '--single-quote'

" JSON
let g:ale_json_prettier_options = '--parser json5'

" Markdown
let g:ale_markdown_prettier_options = '--parser markdown'

" Python
let g:ale_python_black_options = '--line-length 90 --skip-string-normalization'
let g:ale_python_mypy_options = '–-ignore-missing-imports'
" These tools will get run by flake8.
let g:ale_python_prospector_options = '--max-line-length 90 --without-tool mccabe pyflakes'

" typescript
let g:ale_typescript_prettier_options = '--single-quote'
let g:ale_typescriptreact_prettier_options = '--single-quote'

" SQL
let g:ale_sql_sqlformat_options = '--keywords upper --use_space_around_operators --wrap_after 90 --reindent --indent_width 4'

" Shell
let g:ale_sh_shfmt_options = '-i 2 -ci'

" Yaml
let g:ale_yaml_prettier_options = '--parser yaml'


" Plugin: Vim-Airline
" ------------------------------
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#branch#symbol = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#buffer_idx_mode = 1

" Disable to prevent error on startup
let g:airline#extensions#vista#enabled = 0

nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9


" Plugin: Vim-Airline-Themes
" ------------------------------
let g:airline_theme = 'solarized'
let g:airline_solarized_bg = 'dark'


" Plugin: Vim-Gitgutter
" ------------------------------
let g:gitgutter_grep = 'rg'
let g:gitgutter_map_keys = 0
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '*'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '--'
let g:gitgutter_sign_modified_removed = '*-'
let g:gitgutter_sh = $SHELL

" vim: set foldmethod=marker ts=2 sw=0 tw=80 noet :
