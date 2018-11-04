" Write history on idle, for sharing among different sessions
autocmd MyAutoCmd CursorHold * if exists(':rshada') | rshada | wshada | endif

" Search and use environments specifically made for Neovim.
if isdirectory($DATAPATH.'/virtualenvs/neovim')
  let g:python3_host_prog = $DATAPATH.'/virtualenvs/neovim/bin/python'
endif
