" Vim Only Terminal Tweaks: Colors, cursor shape, and tmux
"---------------------------------------------------------

" Paste
" Credits: https://github.com/Shougo/shougo-s-github
" ---
let &t_ti .= "\e[?2004h"
let &t_te .= "\e[?2004l"
let &pastetoggle = "\e[201~"

function! s:XTermPasteBegin(ret) abort
  setlocal paste
  return a:ret
endfunction

noremap  <special> <expr> <Esc>[200~ <SID>XTermPasteBegin('0i')
inoremap <special> <expr> <Esc>[200~ <SID>XTermPasteBegin('')
cnoremap <special> <Esc>[200~ <nop>
cnoremap <special> <Esc>[201~ <nop>

" Mouse settings
" ---
if has('mouse')
  if has('mouse_sgr')
    set ttymouse=sgr
  else
    set ttymouse=xterm2
  endif
endif

" Tmux specific settings
" ---
if exists('$TMUX')
  set ttyfast

  " Set Vim-specific sequences for RGB colors
  " Fixes 'termguicolors' usage in tmux
  " :h xterm-true-color
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

  " Assigns some xterm(1)-style keys to escape sequences passed by tmux
  " when 'xterm-keys' is set to 'on'.  Inspired by an example given by
  " Chris Johnsen at https://stackoverflow.com/a/15471820
  " Credits: Mark Oteiza
  " Documentation: help:xterm-modifier-keys man:tmux(1)
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"

  execute "set <xHome>=\e[1;*H"
  execute "set <xEnd>=\e[1;*F"

  execute "set <Insert>=\e[2;*~"
  execute "set <Delete>=\e[3;*~"
  execute "set <PageUp>=\e[5;*~"
  execute "set <PageDown>=\e[6;*~"

  execute "set <xF1>=\e[1;*P"
  execute "set <xF2>=\e[1;*Q"
  execute "set <xF3>=\e[1;*R"
  execute "set <xF4>=\e[1;*S"

  execute "set <F5>=\e[15;*~"
  execute "set <F6>=\e[17;*~"
  execute "set <F7>=\e[18;*~"
  execute "set <F8>=\e[19;*~"
  execute "set <F9>=\e[20;*~"
  execute "set <F10>=\e[21;*~"
  execute "set <F11>=\e[23;*~"
  execute "set <F12>=\e[24;*~"
endif

" vim: set ts=2 sw=2 tw=80 noet :
