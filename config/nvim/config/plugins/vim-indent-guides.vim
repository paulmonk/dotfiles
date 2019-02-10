" -------------------------------------------------
" Vim-Indent-Guides
" -------------------------------------------------
let g:indent_guides_enable_on_vim_startup = 1
nmap <silent><Leader>ti :<C-u>IndentGuidesToggle<CR>

let g:indent_guides_color_change_percent = 3
let g:indent_guides_autocmds_enabled = 0
let g:indent_guides_default_mapping = 0
let g:indent_guides_guide_size = 1
let g:indent_guides_indent_levels = 15
let g:indent_exclude = ['help', 'denite', 'codi']
autocmd MyAutoCmd BufEnter *
  \ if ! empty(&l:filetype) && index(g:indent_exclude, &l:filetype) == -1
  \|   if g:indent_guides_autocmds_enabled == 0 && &l:expandtab
  \|     IndentGuidesEnable
  \|   elseif g:indent_guides_autocmds_enabled == 1 && ! &l:expandtab
  \|     IndentGuidesDisable
  \|   endif
  \| endif
