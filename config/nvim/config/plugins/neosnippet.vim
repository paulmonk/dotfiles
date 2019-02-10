" -------------------------------------------------
" neosnippet
" -------------------------------------------------
let g:neosnippet#data_directory = $DATAPATH.'/snippets'
imap <expr><C-o> neosnippet#expandable_or_jumpable()
  \ ? "\<Plug>(neosnippet_expand_or_jump)" : "\<ESC>o"
xmap <silent><C-s> <Plug>(neosnippet_register_oneshot_snippet)
smap <silent>L     <Plug>(neosnippet_jump_or_expand)
xmap <silent>L     <Plug>(neosnippet_expand_target)

let g:neosnippet#enable_completed_snippet = 1
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#expand_word_boundary = 1
let g:neosnippet#enable_complete_done = 1
autocmd MyAutoCmd InsertLeave * NeoSnippetClearMarkers
