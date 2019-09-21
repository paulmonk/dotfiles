" -------------------------------------------------
" Tern
" -------------------------------------------------
autocmd user_events FileType javascript,jsx,javascript.jsx
  \  nnoremap <silent><buffer> K          :<C-u>TernDoc<CR>
  \| nnoremap <silent><buffer> <C-]>      :<C-u>TernDefSplit<CR>
  \| nnoremap <silent><buffer> gy         :<C-u>TernType<CR>
  \| nnoremap <silent><buffer> gr         :<C-u>TernRefs<CR>
  \| nnoremap <silent><buffer> <leader>R  :<C-u>TernRename<CR>
