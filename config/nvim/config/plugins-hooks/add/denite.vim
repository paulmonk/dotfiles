" -------------------------------------------------
" Denite
" -------------------------------------------------
nnoremap <silent><LocalLeader>r :<C-u>Denite -resume -refresh -no-start-filter<CR>
nnoremap <silent><LocalLeader>f :<C-u>Denite file/rec<CR>
nnoremap <silent><LocalLeader>b :<C-u>Denite buffer file/old -default-action=switch<CR>
nnoremap <silent><LocalLeader>d :<C-u>Denite directory_rec -default-action=cd<CR>
nnoremap <silent><LocalLeader>v :<C-u>Denite neoyank -buffer-name=register<CR>
xnoremap <silent><LocalLeader>v :<C-u>Denite neoyank -buffer-name=register -default-action=replace<CR>
nnoremap <silent><LocalLeader>n :<C-u>Denite dein<CR>
nnoremap <silent><LocalLeader>g :<C-u>Denite grep -buffer-name=search<CR>
nnoremap <silent><LocalLeader>j :<C-u>Denite jump change file/point -buffer-name=jump<CR>
nnoremap <silent><LocalLeader>o :<C-u>Denite outline<CR>
nnoremap <silent><LocalLeader>t :<C-u>Denite -buffer-name=tag tag:include<CR>
nnoremap <silent><LocalLeader>p :<C-u>Denite jump -buffer-name=jump -mode=normal<CR>
nnoremap <silent><LocalLeader>h :<C-u>Denite help<CR>
nnoremap <silent><LocalLeader>/ :<C-u>Denite line -start-filter<CR>
nnoremap <silent><LocalLeader>* :<C-u>DeniteCursorWord line<CR>
nnoremap <silent><LocalLeader>; :<C-u>Denite command command_history<CR>

" Location List
nnoremap <silent><LocalLeader>l :<C-u>Denite location_list -buffer-name=list<CR>
nnoremap <silent><LocalLeader>q :<C-u>Denite quickfix -buffer-name=list<CR>

" Git
nnoremap <silent><Leader>gl :<C-u>Denite gitlog:all -buffer-name=git<CR>
nnoremap <silent><Leader>gs :<C-u>Denite gitstatus -buffer-name=git<CR>
nnoremap <silent><Leader>gc :<C-u>Denite gitbranch -buffer-name=git<CR>

" Z
nnoremap <silent><LocalLeader>z :<C-u>Denite z<CR>

" Sessions
nnoremap <silent><LocalLeader>s :<C-u>Denite session -buffer-name=list<CR>

" Open Denite with word under cursor or selection
nnoremap <silent> <Leader>gt :DeniteCursorWord tag:include -buffer-name=tag -immediately<CR>
nnoremap <silent> <Leader>gf :DeniteCursorWord file/rec<CR>
nnoremap <silent> <Leader>gg :DeniteCursorWord grep -buffer-name=search<CR>
vnoremap <silent> <Leader>gg
  \ :<C-u>call <SID>get_selection('/')<CR>
  \ :execute 'Denite -buffer-name=search grep:::'.@/<CR><CR>

function! s:get_selection(cmdtype)
  let temp = @s
  normal! gv"sy
  let @/ = substitute(escape(@s, '\'.a:cmdtype), '\n', '\\n', 'g')
  let @s = temp
endfunction
