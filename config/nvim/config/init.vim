" Vim Initialization
" ------------------

" Global Mappings "
" Use spacebar as leader and ; as secondary-leader
" Required before loading plugins!
let g:mapleader="\<Space>"
let g:maplocalleader=';'

" Release keymappings prefixes, evict entirely for use of plug-ins.
nnoremap <Space>  <Nop>
xnoremap <Space>  <Nop>
nnoremap ,        <Nop>
xnoremap ,        <Nop>
nnoremap ;        <Nop>
xnoremap ;        <Nop>
nnoremap m        <Nop>
xnoremap m        <Nop>

" Ensure custom spelling directory
if ! isdirectory(expand('$VIMPATH/spell'))
  call mkdir(expand('$VIMPATH/spell'))
endif


" Protect sensitive information
" ------------------
" Don't backup files in temp directories or shm
if exists('&backupskip')
  set backupskip+=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim
endif

" Don't keep swap files in temp directories or shm
augroup swapskip
  autocmd!
  silent! autocmd BufNewFile,BufReadPre
    \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim
    \ setlocal noswapfile
augroup END

" Don't keep undo files in temp directories or shm
if has('persistent_undo')
  augroup undoskip
    autocmd!
    silent! autocmd BufWritePre
      \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim
      \ setlocal noundofile
  augroup END
endif

" Don't keep viminfo for files in temp directories or shm
augroup viminfoskip
  autocmd!
  silent! autocmd BufNewFile,BufReadPre
    \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim
    \ setlocal viminfo=
augroup END


" Setup dein
" ------------------
let g:dein#auto_recache = 0
let g:dein#install_max_processes = 16
let g:dein#install_progress_type = 'echo'
let g:dein#enable_notification = 0
let g:dein#install_log_filename = $CACHEPATH.'/dein.log'

if &runtimepath !~# '/dein.vim'
  let s:dein_dir = expand('$DATAPATH/dein').'/repos/github.com/Shougo/dein.vim'
  if ! isdirectory(s:dein_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
    if v:shell_error
      echoerr 'dein installation has failed!'
      finish
    endif
  endif

  execute 'set runtimepath+='.substitute(
    \ fnamemodify(s:dein_dir, ':p') , '/$', '', '')
endif

" Disable packpath
set packpath=


" Disable pre-bundled plugins
" ------------------
" Disable menu.vim
if has('gui_running')
  set guioptions=Mc
endif

let g:loaded_2html_plugin = 1
let g:loaded_getscript = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_gzip = 1
let g:loaded_logiPat = 1
let g:loaded_matchit = 1
let g:loaded_matchparen = 1
let g:loaded_netrwFileHandlers = 1
let g:loaded_netrwPlugin = 1
let g:loaded_netrwSettings = 1
let g:loaded_rrhelper = 1
let g:loaded_shada_plugin = 1
let g:loaded_tar = 1
let g:loaded_tarPlugin = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_2html_plugin = 1
let g:loaded_vimball = 1
let g:loaded_vimballPlugin = 1
let g:loaded_zip = 1
let g:loaded_zipPlugin = 1

" vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :
