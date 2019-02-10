" -------------------------------------------------
" Vim-Go
" -------------------------------------------------
let g:go_highlight_array_whitespace_error = 0
let g:go_highlight_chan_whitespace_error = 0
let g:go_highlight_space_tab_error = 0
let g:go_highlight_trailing_whitespace_error = 0
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 0
let g:go_highlight_format_strings = 1
let g:go_highlight_functions = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_operators = 1
let g:go_highlight_string_spellcheck = 0

autocmd MyAutoCmd FileType go
  \   nmap <C-]> <Plug>(go-def)
  \ | nmap <Leader>god  <Plug>(go-describe)
  \ | nmap <Leader>goc  <Plug>(go-callees)
  \ | nmap <Leader>goC  <Plug>(go-callers)
  \ | nmap <Leader>goi  <Plug>(go-info)
  \ | nmap <Leader>gom  <Plug>(go-implements)
  \ | nmap <Leader>gos  <Plug>(go-callstack)
  \ | nmap <Leader>goe  <Plug>(go-referrers)
  \ | nmap <Leader>gor  <Plug>(go-run)
  \ | nmap <Leader>gov  <Plug>(go-vet)
