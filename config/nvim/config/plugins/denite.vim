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
nnoremap <silent> <Leader>gl :<C-u>Denite gitlog:all<CR>
nnoremap <silent> <Leader>gs :<C-u>Denite gitstatus<CR>
nnoremap <silent> <Leader>gc :<C-u>Denite gitbranch<CR>

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

" INTERFACE
call denite#custom#option('_', {
  \ 'prompt': 'λ:',
  \ 'empty': 0,
  \ 'winheight': 16,
  \ 'source_names': 'short',
  \ 'vertical_preview': 1,
  \ 'auto-accel': 1,
  \ 'auto-resume': 1,
  \ })

call denite#custom#option('list', {})

" MATCHERS
" Default is 'matcher/fuzzy'
call denite#custom#source('tag', 'matchers', ['matcher/substring'])

" SORTERS
" Default is 'sorter/rank'
call denite#custom#source('z', 'sorters', ['sorter_z'])

" CONVERTERS
" Default is none
call denite#custom#source(
  \ 'buffer,file_mru,file_old',
  \ 'converters', ['converter_relative_word'])

" FIND and GREP COMMAND
if executable('rg')
  " Ripgrep
  call denite#custom#var('file/rec', 'command',
    \ ['rg', '--files', '--glob', '!.git'])
  call denite#custom#var('grep', 'command', ['rg', '--threads', '1'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', [])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
  call denite#custom#var('grep', 'default_opts',
    \ ['--vimgrep', '--no-heading'])

elseif executable('ag')
  " The Silver Searcher
  call denite#custom#var('file/rec', 'command',
    \ ['ag', '-U', '--hidden', '--follow', '--nocolor', '--nogroup', '-g', ''])

  " Setup ignore patterns in your .agignore file!
  " https://github.com/ggreer/the_silver_searcher/wiki/Advanced-Usage

  call denite#custom#var('grep', 'command', ['ag'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', [])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
  call denite#custom#var('grep', 'default_opts',
    \ [ '--skip-vcs-ignores', '--vimgrep', '--smart-case', '--hidden' ])
endif

" KEY MAPPINGS
let insert_mode_mappings = [
  \  ['jj', '<denite:enter_mode:normal>', 'noremap'],
  \  ['<Esc>', '<denite:enter_mode:normal>', 'noremap'],
  \  ['<C-N>', '<denite:assign_next_matched_text>', 'noremap'],
  \  ['<C-P>', '<denite:assign_previous_matched_text>', 'noremap'],
  \  ['<Up>', '<denite:assign_previous_text>', 'noremap'],
  \  ['<Down>', '<denite:assign_next_text>', 'noremap'],
  \  ['<C-Y>', '<denite:redraw>', 'noremap'],
  \  ['<BS>', '<denite:smart_delete_char_before_caret>', 'noremap'],
  \  ['<C-h>', '<denite:smart_delete_char_before_caret>', 'noremap'],
  \ ]

let normal_mode_mappings = [
  \   ["'", '<denite:toggle_select_down>', 'noremap'],
  \   ['<C-n>', '<denite:jump_to_next_source>', 'noremap'],
  \   ['<C-p>', '<denite:jump_to_previous_source>', 'noremap'],
  \   ['gg', '<denite:move_to_first_line>', 'noremap'],
  \   ['st', '<denite:do_action:tabopen>', 'noremap'],
  \   ['sg', '<denite:do_action:vsplit>', 'noremap'],
  \   ['sv', '<denite:do_action:split>', 'noremap'],
  \   ['sc', '<denite:quit>', 'noremap'],
  \   ['r', '<denite:redraw>', 'noremap'],
  \ ]

for m in insert_mode_mappings
  call denite#custom#map('insert', m[0], m[1], m[2])
endfor
for m in normal_mode_mappings
  call denite#custom#map('normal', m[0], m[1], m[2])
endfor
