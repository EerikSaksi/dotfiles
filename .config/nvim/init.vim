set expandtab
set smarttab
set cindent
set tabstop=2
set foldmethod=manual

set viewoptions-=options
autocmd BufWinLeave *  if expand("%") != "" | mkview | endif
autocmd BufWinEnter *  if expand("%") != "" | silent! loadview | endif
set scl=no

set wrap
set shiftwidth=2

"numbering
set relativenumber
set number

"searching
set ignorecase
set smartcase

"panels
inoremap <C-f> <Esc>:<C-f>
nnoremap <C-f> :<C-f>
vnoremap <C-f> :<C-f>
inoremap  <C-w> <Esc><bar><C-w>

"insert hardcodes
inoremap <C-p> <c-r>=expand("%:p")<CR>

"vim-fugitive
"used to map a command to all modes
function! MapBoth(keys, rhs)
    execute 'nnoremap' a:keys a:rhs
    execute 'vnoremap' a:keys a:rhs
    execute 'inoremap' a:keys '<C-o>' . a:rhs . ' i'
endfunction
call MapBoth('<C-g>c', ':Git commit -a <CR>')
call MapBoth('<C-g>d', ':Gvdiffsplit HEAD~0 <C-f>ge')
call MapBoth('<C-g>?', ':help fugitive <CR>')
call MapBoth('<C-g>a', ':Git add -A <CR>')
call MapBoth('<C-g>p', ':Git push <CR>')
call MapBoth('<C-g>r', ':Gread! show HEAD~0:% <C-f>4h')
call MapBoth('<C-g>l', ':Git diff --name-status HEAD~0 <C-f>ge')
call MapBoth('<C-g>b', ':Git checkout <C-f>')
call MapBoth('<C-g>s', ':Git status <Cr>')
call MapBoth('<C-g>m', ':Git merge <C-f>')


"grep command hard code
cnoremap <C-g> grep -i '' --exclude-dir 'node_modules' --exclude-dir 'public' --exclude-dir 'frontend' --exclude 'package-lock.json' --exclude-dir '.expo' --exclude-dir '.expo-shared' --exclude-dir '.git'  -r .<C-f>^2Wa
nnoremap <C-c> :@c<CR>



"buffers
set laststatus=0
set signcolumn=no
autocmd BufLeave * silent! update
set autochdir
function! s:file_explorer()
  if exists("g:NERDTree") && g:NERDTree.IsOpen()
    :NERDTreeToggle 
  else
    :NERDTreeFind
  endif 
endfunction
nnoremap <silent> <C-n> :call <SID>file_explorer()<CR>
inoremap <silent> <C-n> <Esc>:call <SID>file_explorer()<CR>
vnoremap + :<C-f>is/\V
nnoremap + :<C-f>is/\V

vnoremap S :<C-f>iS/
nnoremap S :<C-f>iS/

"movement                                                                              
nnoremap j gj
nnoremap k gk
nnoremap J gJ
nnoremap $ g$
nnoremap ^ g^
nnoremap / q/i\V
vnoremap / q/i\V
nnoremap <silent> <cr> :set paste<cr>o<esc>:set nopaste<cr>

noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

autocmd CursorMoved *.{tsx} syntax sync fromstart
"copying/selecting
set virtualedit=block 
inoremap <C-v> <Esc>v<C-v>
set clipboard=unnamedplus
set nohlsearch
vnoremap V ^o$
nnoremap - "_d
nnoremap _ "_D
nnoremap <cr> i<cr><Esc>

call plug#begin("~/.config/nvim/plugged")	
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'preservim/nerdtree'
  Plug 'leafgarland/typescript-vim'
  Plug 'peitalin/vim-jsx-typescript'
  Plug 'bkad/CamelCaseMotion'
  Plug 'altercation/vim-colors-solarized'
  Plug 'vuciv/vim-bujo'
  Plug 'honza/vim-snippets'
  Plug 'justinmk/vim-sneak'
  Plug 'tpope/vim-fugitive'
  Plug 'EerikSaksi/vim-marks-overhaul'
  Plug 'rhysd/vim-grammarous'
  Plug 'tpope/vim-abolish'
  Plug 'lervag/vimtex'
  Plug 'leafOfTree/vim-svelte-plugin'
  Plug 'machakann/vim-sandwich'
call plug#end()
nnoremap <silent> ' :OverhaulJump <CR>
nnoremap <silent> " :OverhaulMark<CR>
let g:vim_marks_overhaul#use_globals = 0 

vmap st satdiv.<CR><Space>gv`<<Esc>kf""a

let g:rainbow_active = 1
let g:camelcasemotion_key = 'm'
let g:beacon_shrink = 0
let g:beacon_minimal_jump = 10
let g:neovide_refresh_rate=120
syntax enable

set background=dark

map f <Plug>Sneak_s
map F <Plug>Sneak_S
let g:sneak#s_next = 1

set guifont=Consolas:h18
let g:bujoOpen = 0
call MapBoth('<C-t>', ':call <SID>toggle_bujo()<CR>')

function! s:toggle_bujo()
  if g:bujoOpen
    let g:bujoOpen = 0
    :silent wq
  else 
    let g:bujoOpen = 1
    :Todo
  endif
endfunction


"coc-nvim
let g:coc_snippet_prev = '<c-h>'
let g:coc_snippet_next = '<c-l>'
imap <C-l> <Plug>(coc-snippets-expand-jump)

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

set hidden 
set updatetime=300
set shortmess+=c

inoremap <silent><expr> <c-space> coc#refresh()

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

inoremap <expr><C-k> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr> <C-j>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

nnoremap se :CocCommand snippets.editSnippets<cr>
nnoremap sv :e $MYVIMRC<cr>

nmap <silent><Space> :call CocAction('format')<cr>
nmap <leader>ac  <Plug>(coc-codeaction)
vmap <leader>ac  <Plug>(coc-codeaction-selected)

hi CocFloating ctermbg=20
