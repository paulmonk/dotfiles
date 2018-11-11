" far.vim
" -----------

" Add Ripgrep as a source if installed.
if executable('rg')
  let s:cmd = ['rg', '{pattern}', '--vimgrep',
    \  '--max-count={limit}', '--glob={file_mask}']
  if &smartcase
    call add(s:cmd, '--smart-case')
  endif
  if &ignorecase
    call add(s:cmd, '--ignore-case')
  else
    call add(s:cmd, '--case-sensetive')
  endif

  " Define sources
  let g:far#sources = {}

  " py3 execution
  let g:far#sources.rg = {}
  let g:far#sources.rg.fn = 'far.sources.shell.search'
  let g:far#sources.rg.executor = 'py3'
  let g:far#sources.rg.args = {}
  let g:far#sources.rg.args.cmd = s:cmd
  let g:far#sources.rg.args.fix_cnum = 'next'
  let g:far#sources.rg.args.items_file_min = 30
  let g:far#sources.rg.args.expand_cmdargs = 1

  " nvim execution
  if has('nvim')
    let g:far#sources.rgnvim = {}
    let g:far#sources.rgnvim.fn = 'far.sources.shell.search'
    let g:far#sources.rgnvim.executor = 'nvim'
    let g:far#sources.rgnvim.args = {}
    let g:far#sources.rgnvim.args.cmd = s:cmd
    let g:far#sources.rgnvim.args.fix_cnum = 'next'
    let g:far#sources.rgnvim.args.items_file_min = 30
    let g:far#sources.rgnvim.args.expand_cmdargs = 1
  endif
endif

" vim: set ts=2 sw=2 tw=80 noet :
