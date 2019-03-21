" -------------------------------------------------
" Emmet-Vim
" -------------------------------------------------
autocmd MyAutoCmd FileType html,css,jsx,javascript,javascript.jsx
  \ EmmetInstall
  \ | imap <buffer> <C-Return> <Plug>(emmet-expand-abbr)
