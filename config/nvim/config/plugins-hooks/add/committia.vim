" -------------------------------------------------
" Committia
" -------------------------------------------------
let g:committia_hooks = {}
function! g:committia_hooks.edit_open(info)
  imap <buffer><C-d> <Plug>(committia-scroll-diff-down-half)
  imap <buffer><C-u> <Plug>(committia-scroll-diff-up-half)
  setlocal winminheight=1 winheight=1
  resize 10
  startinsert
endfunction
