" -------------------------------------------------
" Emmet-Vim
" -------------------------------------------------
autocmd user_events FileType html,css,jsx,javascript,javascript.jsx
  \ EmmetInstall
  \ | imap <buffer> <C-Return> <Plug>(emmet-expand-abbr)
