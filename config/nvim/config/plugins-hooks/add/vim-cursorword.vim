" -------------------------------------------------
" Vim-Cursorword
" -------------------------------------------------
autocmd MyAutoCmd FileType denite,qf let b:cursorword=0
autocmd MyAutoCmd WinEnter * if &diff | let b:cursorword=0 | endif
autocmd MyAutoCmd InsertEnter * let b:cursorword=0
autocmd MyAutoCmd InsertLeave * let b:cursorword=1
