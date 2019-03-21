" -------------------------------------------------
" Vim-Bookmarks
" -------------------------------------------------
nmap ma :<C-u>cgetexpr bm#location_list()<CR>
  \ :<C-u>Denite quickfix -buffer-name=list<CR>

nmap mn <Plug>BookmarkNext
nmap mp <Plug>BookmarkPrev
nmap mm <Plug>BookmarkToggle
nmap mi <Plug>BookmarkAnnotate
