" -------------------------------------------------
" Tern
" -------------------------------------------------
autocmd MyAutoCmd FileType javascript,jsx,javascript.jsx
  \  nnoremap <silent><buffer> K          :<C-u>TernDoc<CR>
  \| nnoremap <silent><buffer> <C-]>      :<C-u>TernDefSplit<CR>
  \| nnoremap <silent><buffer> <leader>g  :<C-u>TernType<CR>
  \| nnoremap <silent><buffer> <leader>n  :<C-u>TernRefs<CR>
  \| nnoremap <silent><buffer> <leader>r  :<C-u>TernRename<CR>
