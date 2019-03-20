" -------------------------------------------------
" neosnippet
" -------------------------------------------------
let g:neosnippet#data_directory = $DATAPATH.'/snippets'
imap <expr><C-o> neosnippet#expandable_or_jumpable()
  \ ? "\<Plug>(neosnippet_expand_or_jump)" : "\<ESC>o"
xmap <silent><C-s> <Plug>(neosnippet_register_oneshot_snippet)
smap <silent>L     <Plug>(neosnippet_jump_or_expand)
xmap <silent>L     <Plug>(neosnippet_expand_target)
