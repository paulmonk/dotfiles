" -------------------------------------------------
" auto-git-rebase
" -------------------------------------------------
autocmd MyAutoCmd FileType gitrebase
  \  nmap <buffer><CR>  <Plug>(auto_git_diff_scroll_manual_update)
  \| nmap <buffer><C-n> <Plug>(auto_git_diff_scroll_down_page)
  \| nmap <buffer><C-p> <Plug>(auto_git_diff_scroll_up_page)
  \| nmap <buffer><C-d> <Plug>(auto_git_diff_scroll_down_half)
  \| nmap <buffer><C-u> <Plug>(auto_git_diff_scroll_up_half)
