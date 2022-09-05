"tabs and stuff
set foldmethod=manual
set noshowmode
set noruler
set smarttab
set cindent
set tabstop=2
set shiftwidth=2
set wrap

"always load previous cursor position
set viewoptions-=options
autocmd BufWinLeave * silent! mkview 
autocmd BufWinEnter * silent! loadview 

"no sign column
set scl=no

"numbering
set relativenumber
set number


"used to map to all modes
function! MapBoth(keys, rhs)
    execute 'nnoremap' a:keys a:rhs
    execute 'vnoremap' a:keys a:rhs
    execute 'inoremap' a:keys '<C-o>' . a:rhs . ' i'
endfunction


"vim-fugitive
call MapBoth('<C-g>c', ':Git commit -a <CR>')
call MapBoth('<C-g>d', ':Gvdiffsplit HEAD~0 <C-f>ge')
call MapBoth('<C-g>?', ':help fugitive <CR>')
call MapBoth('<C-g>a', ':Git add -A <CR>')
call MapBoth('<C-g>p', ':Git push <CR>')
call MapBoth('<C-g>r', ':Gread HEAD~0:% <C-f>4h')
call MapBoth('<C-g>l', ':Git diff --name-status HEAD~0 <C-f>ge')
call MapBoth('<C-g>b', ':Git checkout <C-f>')
call MapBoth('<C-g>s', ':Git status <Cr>')
call MapBoth('<C-g>m', ':Git merge <C-f>')
call MapBoth('<C-g>D', ':Gvdiffsplit 80c1004052b9beae32aaff110ce333f201626b73<CR>')
autocmd filetype gitcommit :set tw=100000





"command line
cnoremap <C-g> grep -i '' --exclude-dir 'node_modules' --exclude-dir 'public' --exclude-dir 'frontend' --exclude 'package-lock.json' --exclude-dir '.expo' --exclude-dir '.expo-shared' --exclude-dir '.git' --exclude-dir 'target'  -r .<C-f>^2Wa
call MapBoth('<C-f>', ':<C-f>')


"write finnish lol in .finn files lol
autocmd BufNewFile,BufRead *.finn inoremap o; ö
autocmd BufNewFile,BufRead *.finn inoremap O; Ö
autocmd BufNewFile,BufRead *.finn inoremap a; ä
autocmd BufNewFile,BufRead *.finn inoremap A; Ä

autocmd BufWinEnter * set nofixendofline


"buffers
set laststatus=0
set signcolumn=no
autocmd BufLeave * silent! w
set autochdir

function! s:OpenCocExplorer()
  exe ':CocCommand explorer --toggle --position floating --reveal ' . expand("%:p") 
endfunction
call MapBoth('<silent> <C-n>', ':call <SID>OpenCocExplorer()<CR>')

vnoremap S :<C-f>is/\V
nnoremap S :<C-f>is/\V

vnoremap + :<C-f>iS/
nnoremap + :<C-f>iS/

nnoremap k gk
nnoremap $ g$
nnoremap ^ g^
nnoremap / q/i\V
vnoremap / q/i\V
nnoremap <silent> <cr> :set paste<cr>o<esc>:set nopaste<cr>
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
inoremap <C-u> <Esc><C-u>i
inoremap <C-d> <Esc><C-d>i

"copying/selecting
inoremap <C-v> <Esc>v<C-v>
set clipboard=unnamedplus




vnoremap V ^o$
nnoremap - "_d
nnoremap _ "_D
nnoremap <cr> i<cr><Esc>
call plug#begin("~/.config/nvim/plugged")	
  Plug 'leafgarland/typescript-vim'
  Plug 'peitalin/vim-jsx-typescript'
  Plug 'bkad/CamelCaseMotion'
  Plug 'honza/vim-snippets'
  Plug 'justinmk/vim-sneak'
  Plug 'tpope/vim-fugitive'
	Plug 'rhysd/vim-grammarous'
  Plug 'tpope/vim-abolish'
  Plug 'lervag/vimtex'
  Plug 'leafOfTree/vim-svelte-plugin'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'machakann/vim-sandwich'
  Plug 'jparise/vim-graphql'
  Plug 'EerikSaksi/vim-marks-overhaul'
  Plug 'vuciv/vim-bujo'
  Plug 'puremourning/vimspector'
	Plug 'drzel/vim-gui-zoom'
	Plug 'nanotech/jellybeans.vim'
	Plug 'dracula/vim'
	Plug 'frazrepo/vim-rainbow'
	Plug 'yegappan/mru'
	Plug 'artanikin/vim-synthwave84'
	Plug 'altercation/vim-colors-solarized'
	Plug 'editorconfig/editorconfig-vim'
call plug#end()

let g:rainbow_active = 1

set guifont=Jetbrains\ Mono:h24
nmap <c-+> :ZoomIn<CR>
nmap <c--> :ZoomOut<CR>
inoremap <c-=> <Esc>:ZoomIn<CR>i
inoremap <c--> <Esc>:ZoomOut<CR>i

syntax enable
"set termguicolors
"hi! Normal ctermbg=NONE guibg=NONE
"hi! NonText ctermbg=NONE guibg=NONE
"hi CursorLine term=bold cterm=bold guibg=Grey40
set background=dark
colorscheme jellybeans

nnoremap <silent> t :OverhaulJump<CR>
nnoremap <silent> T :OverhaulMark<CR>

let g:camelcasemotion_key = 'm'

"Misc plugin
nmap sg <Plug>(grammarous-open-info-window)





"Searching
map f <Plug>Sneak_s
map F <Plug>Sneak_S
map n <Plug>Sneak_;
map N <Plug>Sneak_,
nnoremap , n
nnoremap # N
vnoremap , n
vnoremap # N
set ignorecase
set smartcase
set nohlsearch

"neovide
let g:neovide_transparency=0.8
nnoremap <C-=> :ZoomIn<CR>
nnoremap <C--> :ZoomOut<CR>
let g:neovide_cursor_vfx_mode = "sonicboom"
let g:neovide_cursor_animation_length=0.015
let g:neovide_refresh_rate=144


"todo list
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

"file specific

"compile latex after saving
autocmd BufWritePost *.tex silent !pdflatex <afile>
autocmd BufRead *.tex :set spell
vmap st satdiv.<CR><Space>gv`<<Esc>kf""a



"coc-nvim
let g:coc_snippet_prev = '<c-h>'
let g:coc_snippet_next = '<c-l>'
imap <C-l> <Plug>(coc-snippets-expand-jump)
vmap <C-l> <Plug>(coc-snippets-select)

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


inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <C-x><C-z> coc#pum#visible() ? coc#pum#stop() : "\<C-x>\<C-z>"

let g:coc_disable_startup_warning = 1

" remap for complete to use tab and <cr>
inoremap <silent><expr> <TAB>
			\ coc#pum#visible() ? coc#pum#next(1):
			\ <SID>check_back_space() ? "\<Tab>" :
			\ coc#refresh()
inoremap <expr><C-k> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <expr><C-j> coc#pum#visible() ? coc#pum#next(1) : "\<C-h>"
inoremap <silent><expr> <c-space> coc#refresh()


nnoremap sn :CocCommand snippets.editSnippets<cr>
nnoremap sv :e $MYVIMRC <bar> source $MYVIMRC<cr>

nmap <silent><Space> :call CocAction('format')<cr>
nmap <leader>ac  <Plug>(coc-codeaction)
vmap <leader>ac  <Plug>(coc-codeaction-selected)


nmap R <Plug>(coc-rename)

xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
let g:coc_global_extensions = ['coc-explorer', 'coc-prettier', 'coc-pairs', 'coc-vimtex', 'coc-tsserver', 'coc-svelte', 'coc-sql', 'coc-json', 'coc-snippets', 'coc-rust-analyzer', 'coc-java', 'coc-tailwindcss', 'coc-pyright']

au User CocExplorerOpenPost set relativenumber


inoremap <C-P> <C-\><C-O>:call CocActionAsync('showSignatureHelp')<cr>

if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-d>"
  nnoremap <nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-u>"
  inoremap <nowait><expr> <C-d> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <nowait><expr> <C-u> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-d>"
  vnoremap <nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-u>"
endif

"vimspector
let g:vimspector_install_gadgets = [ 'debugpy', 'CodeLLDB' ]
nnoremap zc :call vimspector#Continue()<CR>

function! s:VimspectorCustomReset()
	:call vimspector#Reset()
	sleep 1m 
	call vimspector#LaunchWithSettings( { 'configuration': 'attached'} )
endfunction

function! s:VimspectorBuildAndRunBinary() 
	:call vimspector#Reset()
	sleep 50m
	silent !cargo test --no-run 
	let directory_root = trim(system("git rev-parse --show-toplevel"))
	let basename = trim(system("basename " . directory_root))
	echo 'find ' . directory_root . '/target/debug/deps/ -name  "' . basename . '*" -executable -exec ls -1rt "{}" +| tail -n 1'
	let test_binary = trim(system('find ' . directory_root . '/target/debug/deps/ -name  "' . basename . '*" -executable -exec ls -1rt "{}" +| tail -n 1'))
	call vimspector#LaunchWithSettings( { 'configuration': 'Test', 'programName': test_binary } )
endfunction


nnoremap zR :call <SID>VimspectorBuildAndRunBinary()<CR>

"autocmd FocusLost * :silent! exe '!code ' . expand('%:p')

nnoremap zr :call <SID>VimspectorCustomReset()<CR>
nnoremap zr :silent! exe '!code ' . expand('%:p')<CR>

nnoremap zb :call vimspector#ToggleBreakpoint()<bar>:set scl=yes<CR>
nnoremap zt :call vimspector#RunToCursor()<CR>
nnoremap zz :call vimspector#Reset()<bar>:set scl=no<CR>
nnoremap zB :call vimspector#ClearBreakpoints()<CR>
nmap zK <Plug>VimspectorBalloonEval
let g:vimspector_sidebar_width = 40
function! s:CustomiseUI()
  "call win_gotoid( g:vimspector_session_windows.output )
  "q
	set scl=yes
endfunction



augroup MyVimspectorUICustomistaion
  autocmd!
  autocmd User VimspectorUICreated call s:CustomiseUI()
augroup END

function! s:watch_visual()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    exe ':VimspectorWatch ' . join(lines, "\n")
endfunction
vnoremap zw :call <SID>watch_visual()<CR>
nnoremap zo <C-w>h<C-w>h<C-w>k<C-w>k<C-w>T
nnoremap zO mAZZ<C-w>S`A<C-w>l
set nofixeol
