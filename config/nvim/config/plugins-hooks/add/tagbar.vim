" -------------------------------------------------
" Tagbar
" -------------------------------------------------
nnoremap <silent> <Leader>o   :<C-u>TagbarOpenAutoClose<CR>

" Also use h/l to open/close folds
let g:tagbar_map_closefold = ['h', '-', 'zc']
let g:tagbar_map_openfold = ['l', '+', 'zo']
