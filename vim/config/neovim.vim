" Write history on idle, for sharing among different sessions
autocmd MyAutoCmd CursorHold * if exists(':rshada') | rshada | wshada | endif

" Search and use environments specifically made for Neovim.
if isdirectory($DATAPATH.'/virtualenv')
  let g:python3_host_prog = $DATAPATH.'/virtualenv/bin/python'
endif
