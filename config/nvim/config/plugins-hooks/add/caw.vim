" -------------------------------------------------
" Caw
" -------------------------------------------------
function! InitCaw() abort
  if ! &l:modifiable
    silent! nunmap <buffer> <Leader>V
    silent! xunmap <buffer> <Leader>V
    silent! nunmap <buffer> <Leader>v
    silent! xunmap <buffer> <Leader>v
    silent! nunmap <buffer> gc
    silent! xunmap <buffer> gc
    silent! nunmap <buffer> gcc
    silent! xunmap <buffer> gcc
  else
    xmap <buffer> <Leader>V <Plug>(caw:wrap:toggle)
    nmap <buffer> <Leader>V <Plug>(caw:wrap:toggle)
    xmap <buffer> <Leader>v <Plug>(caw:hatpos:toggle)
    nmap <buffer> <Leader>v <Plug>(caw:hatpos:toggle)
    nmap <buffer> gc <Plug>(caw:prefix)
    xmap <buffer> gc <Plug>(caw:prefix)
    nmap <buffer> gcc <Plug>(caw:hatpos:toggle)
    xmap <buffer> gcc <Plug>(caw:hatpos:toggle)
  endif
endfunction

autocmd MyAutoCmd FileType * call InitCaw()

call InitCaw()
