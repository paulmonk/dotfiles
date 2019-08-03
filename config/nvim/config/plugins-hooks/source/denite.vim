" -------------------------------------------------
" Denite
" -------------------------------------------------
" INTERFACE
call denite#custom#option('_', {
  \ 'auto-resume': 1,
  \ 'empty': 0,
  \ 'highlight_filter_background': 'CursorLine',
  \ 'highlight_prompt': 'Function',
  \ 'highlight_window_background': 'CursorColumn',
  \ 'prompt': '❯ ',
  \ 'start_filter': 1,
  \ 'statusline': 1,
  \ 'winwidth': &columns,
  \ 'winheight': &lines / 3,
  \ 'wincol': 0,
  \ 'winrow': (&lines - 3) - (&lines / 3),
  \ 'vertical_preview': 1,
  \ })

if has('nvim')
  call denite#custom#option('_', { 'split': 'floating' })
endif

call denite#custom#option('git', { 'start_filter': 0 })
call denite#custom#option('jump', { 'start_filter': 0 })
call denite#custom#option('list', { 'start_filter': 0 })
call denite#custom#option('search', { 'start_filter': 0, 'no_empty': 1 })

" MATCHERS
" Default is 'matcher/fuzzy'
call denite#custom#source('tag', 'matchers', ['matcher/substring'])

" SORTERS
" Default is 'sorter/rank'
call denite#custom#source('file/rec,grep', 'sorters', ['sorter/sublime'])
call denite#custom#source('z', 'sorters', ['sorter_z'])

" CONVERTERS
" Default is none
call denite#custom#source(
  \ 'buffer,file_mru,file_old',
  \ 'converters', ['converter_relative_word'])

" FIND and GREP COMMAND
if executable('rg')
  " Ripgrep
  call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])
  call denite#custom#var('grep', 'command', ['rg', '--threads', '1'])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'final_opts', [])
  call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep', '--no-heading'])

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
autocmd MyAutoCmd FileType denite call s:denite_settings()
function! s:denite_settings() abort
  " highlight! link CursorLine Visual
  nnoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
  nnoremap <silent><buffer><expr> i    denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> /    denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> dd   denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p    denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> st   denite#do_map('do_action', 'tabopen')
  nnoremap <silent><buffer><expr> sg   denite#do_map('do_action', 'vsplit')
  nnoremap <silent><buffer><expr> sv   denite#do_map('do_action', 'split')
  nnoremap <silent><buffer><expr> '    denite#do_map('quick_move')
  nnoremap <silent><buffer><expr> q    denite#do_map('quit')
  nnoremap <silent><buffer><expr> r    denite#do_map('redraw')
  nnoremap <silent><buffer><expr> yy   denite#do_map('do_action', 'yank')
  nnoremap <silent><buffer><expr> <Esc>   denite#do_map('quit')
  nnoremap <silent><buffer><expr> <Tab>   denite#do_map('choose_action')
  nnoremap <silent><buffer><expr><nowait> <Space> denite#do_map('toggle_select').'j'
endfunction

autocmd MyAutoCmd FileType denite-filter call s:denite_filter_settings()
function! s:denite_filter_settings() abort
  nnoremap <silent><buffer><expr> <Esc>  denite#do_map('quit')
  " inoremap <silent><buffer><expr> <Esc>  denite#do_map('quit')
  nnoremap <silent><buffer><expr> q      denite#do_map('quit')
  inoremap <silent><buffer><expr> <C-c>  denite#do_map('quit')
  nnoremap <silent><buffer><expr> <C-c>  denite#do_map('quit')
  inoremap <silent><buffer>       kk     <Esc><C-w>p
  nnoremap <silent><buffer>       kk     <C-w>p
  inoremap <silent><buffer>       jj     <Esc><C-w>p
  nnoremap <silent><buffer>       jj     <C-w>p
endfunction
