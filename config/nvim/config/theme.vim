" Theme
" -----
" Enable 256 color terminal
set t_Co=256

" Enable true color
if has('termguicolors')
  set termguicolors
endif

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
" ---------------------------------------------------------
highlight! link pythonSpaceError  NONE
highlight! link pythonIndentError NONE
highlight! link ExtraWhitespace  SpellBad
highlight! WarningMsg ctermfg=100 guifg=#CCC566

" Plugin: denite
" ---------------------------------------------------------
highlight! clear WildMenu
highlight! link WildMenu CursorLine
highlight! link deniteSelectedLine Type
highlight! link deniteMatchedChar Function
highlight! link deniteMatchedRange Underlined
highlight! link deniteMode Comment
highlight! link deniteSource_QuickfixPosition qfLineNr

" Plugin: vim-bookmarks
" ---------------------------------------------------------
highlight! BookmarkSign            ctermfg=12 guifg=#4EA9D7
highlight! BookmarkAnnotationSign  ctermfg=11 guifg=#EACF49

" Plugin: vim-gitgutter
" ---------------------------------------------------------
highlight! GitGutterAdd ctermfg=22 guifg=#006000 ctermbg=NONE guibg=NONE
highlight! GitGutterChange ctermfg=58 guifg=#5F6000 ctermbg=NONE guibg=NONE
highlight! GitGutterDelete ctermfg=52 guifg=#600000 ctermbg=NONE guibg=NONE
highlight! GitGutterChangeDelete ctermfg=52 guifg=#600000 ctermbg=NONE guibg=NONE

" Plugin: vim-javascript
" ---------------------------------------------------------
highlight! link jsFutureKeys PreProc

" Plugin: vim-operator-flashy
" ---------------------------------------------------------
highlight! link Flashy DiffText

" vim: set foldmethod=marker ts=2 sw=0 tw=80 noet :
