" -------------------------------------------------
" neosnippet
" -------------------------------------------------
let g:neosnippet#enable_completed_snippet = 1
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#expand_word_boundary = 1
let g:neosnippet#enable_complete_done = 1
autocmd MyAutoCmd InsertLeave * NeoSnippetClearMarkers
