" -------------------------------------------------
" Emmet-Vim
" -------------------------------------------------
autocmd MyAutoCmd FileType html,css,jsx,javascript,javascript.jsx
  \ EmmetInstall
  \ | imap <buffer> <C-Return> <Plug>(emmet-expand-abbr)

let g:use_emmet_complete_tag = 0
let g:user_emmet_install_global = 0
let g:user_emmet_install_command = 0
let g:user_emmet_mode = 'i'
