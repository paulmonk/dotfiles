
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
  set background=dark
  set lines=40
  set columns=150
endif

" THEME
function! s:theme_reload(name)
  let theme_path = $VIMPATH.'/themes/'.a:name.'.vim'
  if filereadable(theme_path)
    execute 'source' fnameescape(theme_path)
    " Persist theme
    call writefile([g:colors_name], s:cache)
  endif
endfunction

" THEME NAME
let g:theme_name = 'solarized-custom'
autocmd MyAutoCmd ColorScheme * call s:theme_reload(g:theme_name)

" COLORSCHEME NAME
let s:cache = $CACHEPATH.'/theme.txt'
if ! exists('g:colors_name')
  set background=dark
  execute 'colorscheme'
    \ filereadable(s:cache) ? readfile(s:cache)[0] : 'solarized8'
endif

" vim: set ts=2 sw=2 tw=80 noet :
