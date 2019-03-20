" -------------------------------------------------
" vim-easymotion
" -------------------------------------------------
nmap ss <Plug>(easymotion-s2)
nmap sd <Plug>(easymotion-s)
nmap sf <Plug>(easymotion-overwin-f)
map  sh <Plug>(easymotion-linebackward)
map  sl <Plug>(easymotion-lineforward)
" map  sj <Plug>(easymotion-j)
" map  sk <Plug>(easymotion-k)
map  s/ <Plug>(easymotion-sn)
omap s/ <Plug>(easymotion-tn)
map  sn <Plug>(easymotion-next)
map  sp <Plug>(easymotion-prev)

let g:EasyMotion_do_mapping = 0
let g:EasyMotion_prompt = 'Jump to → '
let g:EasyMotion_keys = 'fjdksweoavn'
let g:EasyMotion_smartcase = 1
let g:EasyMotion_use_smartsign_us = 1
