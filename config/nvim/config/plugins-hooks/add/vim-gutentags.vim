" -------------------------------------------------
" Vim-gutentags
" -------------------------------------------------
let g:gutentags_cache_dir = $DATA_PATH.'/tags'
let g:gutentags_ctags_exclude_wildignore = 1
let g:gutentags_ctags_exclude = [
  \ '.idea', '.cache', '.tox', '.bundle', 'build', 'dist',
  \ '*/wp-admin', '*/wp-content', '*/wp-includes',
  \ '*/application/vendor', '*/vendor/ckeditor', '*/media/vendor'
  \ ]
let g:gutentags_exclude_filetypes = ['defx', 'denite', 'gitcommit', 'gitrebase', 'magit', 'vista']
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_new = 0
let g:gutentags_generate_on_write = 1
