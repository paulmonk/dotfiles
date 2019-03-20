" -------------------------------------------------
" Tern
" -------------------------------------------------
let g:tern#command = ['tern']
let g:tern#arguments = ['--persistent']
let g:tern_request_timeout = 1
let g:tern_show_signature_in_pum = 0

autocmd MyAutoCmd FileType javascript,jsx,javascript.jsx
  \  nnoremap <silent><buffer> K          :<C-u>TernDoc<CR>
  \| nnoremap <silent><buffer> <C-]>      :<C-u>TernDefSplit<CR>
  \| nnoremap <silent><buffer> <leader>g  :<C-u>TernType<CR>
  \| nnoremap <silent><buffer> <leader>n  :<C-u>TernRefs<CR>
  \| nnoremap <silent><buffer> <leader>r  :<C-u>TernRename<CR>
