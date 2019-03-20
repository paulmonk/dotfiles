" -------------------------------------------------
" Denite
" -------------------------------------------------
nnoremap <silent><LocalLeader>r :<C-u>Denite -resume -refresh -mode=normal<CR>
nnoremap <silent><LocalLeader>f :<C-u>Denite file/rec<CR>
nnoremap <silent><LocalLeader>b :<C-u>Denite buffer file_old -default-action=switch<CR>
nnoremap <silent><LocalLeader>d :<C-u>Denite directory_rec -default-action=cd<CR>
nnoremap <silent><LocalLeader>v :<C-u>Denite neoyank -buffer-name=register<CR>
xnoremap <silent><LocalLeader>v :<C-u>Denite neoyank -buffer-name=register -default-action=replace<CR>
nnoremap <silent><LocalLeader>n :<C-u>Denite dein<CR>
nnoremap <silent><LocalLeader>g :<C-u>Denite grep -buffer-name=search -no-empty -mode=normal<CR>
nnoremap <silent><LocalLeader>j :<C-u>Denite jump change file/point -mode=normal<CR>
nnoremap <silent><LocalLeader>o :<C-u>Denite outline<CR>
nnoremap <silent><LocalLeader>t :<C-u>Denite -buffer-name=tag tag:include<CR>
nnoremap <silent><LocalLeader>p :<C-u>Denite jump -buffer-name=jump -mode=normal<CR>
nnoremap <silent><LocalLeader>h :<C-u>Denite help<CR>
nnoremap <silent><LocalLeader>/ :<C-u>Denite line -buffer-name=search -auto-highlight<CR>
nnoremap <silent><LocalLeader>* :<C-u>DeniteCursorWord line -buffer-name=search -auto-highlight -mode=normal<CR>
nnoremap <silent><LocalLeader>; :<C-u>Denite command command_history<CR>

" Open Denite with word under cursor or selection
nnoremap <silent> <Leader>gt :DeniteCursorWord tag:include -buffer-name=tag -immediately<CR>
nnoremap <silent> <Leader>gf :DeniteCursorWord file/rec<CR>
nnoremap <silent> <Leader>gg :DeniteCursorWord grep -buffer-name=search<CR>
vnoremap <silent> <Leader>gg
  \ :<C-u>call <SID>get_selection('/')<CR>
  \ :execute 'Denite -buffer-name=search grep:::'.@/<CR><CR>

" Location List
nnoremap <silent><LocalLeader>l :<C-u>Denite location_list -buffer-name=list<CR>
nnoremap <silent><LocalLeader>q :<C-u>Denite quickfix -buffer-name=list<CR>

" Git
nnoremap <silent><Leader>gl :<C-u>Denite gitlog:all<CR>
nnoremap <silent><Leader>gs :<C-u>Denite gitstatus<CR>
nnoremap <silent><Leader>gc :<C-u>Denite gitbranch<CR>

" Z
nnoremap <silent><LocalLeader>z :<C-u>Denite z -buffer-name=jump<CR>

" Sessions
nnoremap <silent><LocalLeader>s :<C-u>Denite session -buffer-name=list<CR>

function! s:get_selection(cmdtype)
  let temp = @s
  normal! gv"sy
  let @/ = substitute(escape(@s, '\'.a:cmdtype), '\n', '\\n', 'g')
  let @s = temp
endfunction
