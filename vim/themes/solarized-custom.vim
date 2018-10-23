" solarized-custom
" =========================

" UI elements
" ---------------------------------------------------------
set showbreak=↪
set fillchars=vert:│,fold:─
set listchars=tab:\—\ ,extends:⟫,precedes:⟪,nbsp:␣,trail:·


" Tabline
" ---------------------------------------------------------
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'jsformatter'
"

" Statusline
" Use vim-airline
let g:airline_theme = 'solarized'
let g:airline_solarized_bg = 'dark'
let g:airline#extensions#branch#symbol = ''
"

" Highlights: General GUI
" ---------------------------------------------------------
" highlight! Error  term=NONE cterm=NONE
" highlight! link WarningMsg  Comment
highlight! link pythonSpaceError  NONE
highlight! link pythonIndentError NONE
" highlight! link mkdLineBreak      NONE
highlight! link ExtraWhitespace  SpellBad
highlight! WarningMsg ctermfg=100 guifg=#CCC566
"

" Plugin: NERDTree icons and highlights
" ---------------------------------------------------------
let g:NERDTreeIndicatorMapCustom = {
  \ 'Modified':  '·',
  \ 'Staged':    '‧',
  \ 'Untracked': '?',
  \ 'Renamed':   '≫',
  \ 'Unmerged':  '≠',
  \ 'Deleted':   '✃',
  \ 'Dirty':     '⁖',
  \ 'Clean':     '✓',
  \ 'Unknown':   '⁇'
  \ }

let g:NERDTreeDirArrowExpandable = '▷'
let g:NERDTreeDirArrowCollapsible = '▼'

highlight! NERDTreeOpenable ctermfg=132 guifg=#B05E87
highlight! def link NERDTreeClosable NERDTreeOpenable

highlight! NERDTreeFile ctermfg=246 guifg=#999999
highlight! NERDTreeExecFile ctermfg=246 guifg=#999999

highlight! clear NERDTreeFlags
highlight! NERDTreeFlags ctermfg=234 guifg=#1d1f21
highlight! NERDTreeCWD ctermfg=240 guifg=#777777

highlight! NERDTreeGitStatusModified ctermfg=1 guifg=#D370A3
highlight! NERDTreeGitStatusStaged ctermfg=10 guifg=#A3D572
highlight! NERDTreeGitStatusUntracked ctermfg=12 guifg=#98CBFE
highlight! def link NERDTreeGitStatusRenamed Title
highlight! def link NERDTreeGitStatusUnmerged Label
highlight! def link NERDTreeGitStatusDirDirty Constant
highlight! def link NERDTreeGitStatusDirClean DiffAdd
highlight! def link NERDTreeGitStatusUnknown Comment

function! s:NERDTreeHighlight()
  for l:name in keys(g:NERDTreeIndicatorMapCustom)
    let l:icon = g:NERDTreeIndicatorMapCustom[l:name]
    if empty(l:icon)
        continue
    endif
    let l:prefix = index(['Dirty', 'Clean'], l:name) > -1 ? 'Dir' : ''
    let l:hiname = escape('NERDTreeGitStatus'.l:prefix.l:name, '~')
    execute 'syntax match '.l:hiname.' #'.l:icon.'# containedin=NERDTreeFlags'
  endfor

    syntax match hideBracketsInNerdTree "\]" contained conceal containedin=NERDTreeFlags
    syntax match hideBracketsInNerdTree "\[" contained conceal containedin=NERDTreeFlags
endfunction

augroup nerdtree-highlights
  autocmd!
  autocmd FileType nerdtree call s:NERDTreeHighlight()
augroup END
"

" Plugin: Tagbar icons
" ---------------------------------------------------------
let g:tagbar_iconchars = ['▷', '◢']
"

" Plugin: Ale Icons
" ---------------------------------------------------------
let g:ale_sign_error = '!'
let g:ale_sign_warning = '!'
let g:ale_sign_info = 'ℹ'

" Plugin: GitGutter icons
" ---------------------------------------------------------
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '*'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '--'
let g:gitgutter_sign_modified_removed = '*-'
"

" Plugin: vim-gitgutter
" ---------------------------------------------------------
highlight! GitGutterAdd ctermfg=22 guifg=#006000 ctermbg=NONE guibg=NONE
highlight! GitGutterChange ctermfg=58 guifg=#5F6000 ctermbg=NONE guibg=NONE
highlight! GitGutterDelete ctermfg=52 guifg=#600000 ctermbg=NONE guibg=NONE
highlight! GitGutterChangeDelete ctermfg=52 guifg=#600000 ctermbg=NONE guibg=NONE
"

" Plugin: denite
" ---------------------------------------------------------
highlight! clear WildMenu
highlight! link WildMenu CursorLine
highlight! link deniteSelectedLine Type
highlight! link deniteMatchedChar Function
highlight! link deniteMatchedRange Underlined
highlight! link deniteMode Comment
highlight! link deniteSource_QuickfixPosition qfLineNr
"

" Plugin: vim-operator-flashy
" ---------------------------------------------------------
highlight! link Flashy DiffText
"

" Plugin: vim-bookmarks
let g:bookmark_sign = '⚐'
highlight! BookmarkSign            ctermfg=12 guifg=#4EA9D7
highlight! BookmarkAnnotationSign  ctermfg=11 guifg=#EACF49
"

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
"

" vim: set foldmethod=marker ts=2 sw=0 tw=80 noet :
