" -------------------------------------------------
" Vim-Bookmarks
" -------------------------------------------------
nmap ma :<C-u>cgetexpr bm#location_list()<CR>
  \ :<C-u>Denite quickfix -buffer-name=list<CR>

nmap mn <Plug>BookmarkNext
nmap mp <Plug>BookmarkPrev
nmap mm <Plug>BookmarkToggle
nmap mi <Plug>BookmarkAnnotate

let g:bookmark_auto_save_file = $DATAPATH.'/bookmarks'
let g:bookmark_disable_ctrlp = 1
let g:bookmark_no_default_key_mappings = 1
let g:bookmark_sign = '⚐'
