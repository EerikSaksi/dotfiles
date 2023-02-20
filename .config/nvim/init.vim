set noruler
set smarttab
set cindent
set tabstop=2
set shiftwidth=2
set wrap


"always load previous cursor position
set viewoptions-=options
autocmd BufWinLeave * silent! mkview 
if exists('g:vscode')
	autocmd BufRead * silent! loadview 
else
	autocmd BufWinEnter * silent! loadview 
endif

"no sign column
set scl=yes

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
call MapBoth('<C-g>d', ':Gvdiffsplit HEAD<CR>') 
call MapBoth('<C-g>D', ':Gvdiffsplit master<CR>') 
call MapBoth('<C-g>a', ':Git add -A <CR>')
call MapBoth('<C-g>p', ':Git push <CR>')
call MapBoth('<C-g>r', ':Gread HEAD<C-f>4h<Esc>r')
call MapBoth('<C-g>h', ':Git checkout %<CR>')
call MapBoth('<C-g>H', ':Git checkout master -- %<CR>')
call MapBoth('<C-g>l', ':Git difftool<CR><C-w>j')
call MapBoth('<C-g>L', ':Git difftool master<CR><C-w>j')
call MapBoth('<C-g>s', ':Git status <CR>')
call MapBoth('<C-g>m', ':Git merge <C-f>')


function! s:GitToCarets()
	call MapBoth('<C-g>d', ':Gvdiffsplit HEAD^0 <CR>') 
	call MapBoth('<C-g>r', ':Gread HEAD^0:% <C-f>4h<Esc>r')
endfunction
call MapBoth('<silent> <C-g>^', ':call <SID>GitToCarets()<CR>')





function! s:GitHistory()
	let url="" |gredir => url | silent! GBrowse! | redir END 
	exe "GBrowse " . trim(substitute(url, "blob", "commits", ""))
endfunction
nmap [h <Plug>(coc-git-prevchunk)
nmap ]h <Plug>(coc-git-nextchunk)
let g:EditorConfig_exclude_patterns = ['fugitive://.*']


set inccommand=nosplit


let $FZF_DEFAULT_OPTS="--bind ctrl-u:half-page-up,ctrl-d:half-page-down"


call MapBoth('<C-f>', ':<C-f>')



command! -bang -nargs=* FzfGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number --untracked -- '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': getcwd()}), <bang>0)


nnoremap gz :FzfGrep <C-f>i


"write umlauts in .finn files 
autocmd BufNewFile,BufRead *.finn inoremap o; ö
autocmd BufNewFile,BufRead *.finn inoremap O; Ö
autocmd BufNewFile,BufRead *.finn inoremap a; ä
autocmd BufNewFile,BufRead *.finn inoremap A; Ä

autocmd BufWinEnter * set nofixendofline


"buffers
set laststatus=0
autocmd BufLeave * silent! w
set autochdir


function! s:OpenCocExplorer()
  exe ':CocCommand explorer --toggle --sources file+ --position floating --reveal ' . expand("%:p") 
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
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
inoremap <C-u> <Esc><C-u>i
inoremap <C-d> <Esc><C-d>i
vnoremap / o/\%V

nnoremap yL /struct Solution<CR>jv/fn main<CR>ky


"copying/selecting
inoremap <C-v> <Esc>v<C-v>
set clipboard=unnamedplus

set mouse=


vnoremap V ^o$
nnoremap - "_d
nnoremap _ "_D
vnoremap p pgvy
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
  Plug 'puremourning/vimspector'
	Plug 'drzel/vim-gui-zoom'
	Plug 'frazrepo/vim-rainbow'
	Plug 'yegappan/mru'
	Plug 'editorconfig/editorconfig-vim'
	Plug 'michaeljsmith/vim-indent-object'
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
call plug#end()

lua require('plugins')

let g:rainbow_active = 1

set guifont=Jetbrains\ Mono:h24
nmap <c-+> :ZoomIn<CR>
nmap <c--> :ZoomOut<CR>
inoremap <c-=> <Esc>:ZoomIn<CR>i
inoremap <c--> <Esc>:ZoomOut<CR>i

syntax enable
set t_8f=\[[38;2;%lu;%lu;%lum
set t_8b=\[[48;2;%lu;%lu;%lum
set termguicolors
set background=dark

nnoremap <silent> t :OverhaulJump<CR>
nnoremap <silent> T :OverhaulMark<CR>

let g:camelcasemotion_key = 'm'

"Misc plugin
nmap sg <Plug>(grammarous-open-info-window)



if has('persistent_undo')
    " define a path to store persistent undo files.
    let target_path = expand('~/.config/vim-persisted-undo/')
    " create the directory and any parent directories
    " if the location does not exist.
    if !isdirectory(target_path)
        call system('mkdir -p ' . target_path)
    endif
    " point Vim to the defined undo directory.
    let &undodir = target_path
    " finally, enable undo persistence.
    set undofile
endif



"Searching
map f <Plug>(leap-forward-to)
map F <Plug>(leap-backward-to)

set ignorecase
set smartcase
set nohlsearch

"neovide
let g:neovide_transparency=0.6
nnoremap <C-=> :ZoomIn<CR>
nnoremap <C--> :ZoomOut<CR>
let g:neovide_cursor_vfx_mode="ripple"
let g:neovide_cursor_animation_length=0.03
let g:neovide_cursor_vfx_particle_density = 5000.0
let g:neovide_cursor_vfx_opacity = 2000.0

nnoremap <silent> yp :let @+ = expand("%")<CR>
nnoremap <silent> yP :let @+ = expand("%:p")<CR>




"compile latex after saving
autocmd BufWritePost *.tex silent !pdflatex <afile>
autocmd BufRead *.tex :set spell



"coc-nvim
let g:coc_snippet_prev = '<c-h>'
let g:coc_snippet_next = '<c-l>'
inoremap <C-l> <Plug>(coc-snippets-expand)
vnoremap <C-l> <Plug>(coc-snippets-select)

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


"let g:play_boom = 1
"function! s:has_diagnostics()
"	if CocAction('diagnosticList') == [] 
"		call jobstart("killall mpv")
"		let g:play_boom=1
"	else
"		if g:play_boom
"			call jobstart("mpv ~/Downloads/what-the-hell_H0K7ORA.mp3")
"			let g:play_boom=0
"		endif
"	endif
"endfunction
autocmd CursorMoved * silent! call <SID>has_diagnostics()

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


nnoremap <C-t>n :CocCommand snippets.editSnippets<cr>
nnoremap <C-t>v :e $MYVIMRC <bar> source $MYVIMRC<cr>
nnoremap <C-t>l :e ~/.config/nvim/lua/plugins.lua<cr>

nmap <silent><Space> :call CocAction('format')<cr>
vmap <silent><Space> <Plug>(coc-format-selected)
nmap <leader>ac  <Plug>(coc-codeaction)
vmap <leader>ac  <Plug>(coc-codeaction-selected)


nmap R <Plug>(coc-rename)

xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(fcoc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gi <Plug>(coc-implementation)
let g:coc_global_extensions = ['coc-explorer', 'coc-prettier', 'coc-pairs', 'coc-vimtex', 'coc-tsserver', 'coc-svelte', 'coc-sql', 'coc-json', 'coc-snippets', 'coc-rust-analyzer', 'coc-java', 'coc-tailwindcss', 'coc-pyright', 'coc-tsserver', 'coc-html', 'coc-git', 'coc-lists', 'coc-clangd']
"'coc-fzf-preview' ]

au User CocExplorerOpenPost set relativenumber


" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')


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
	"autocmd CursorHold *.rs call g:vimspector#ShowEvalBalloon(0)
	if get(g:vimspector_session_windows, 'code') == 0
		call vimspector#LaunchWithSettings({'configuration': 'Regular'})
	else
		sleep 1000m
		call vimspector#Restart()
	endif
endfunction

function! s:VimspectorBuildAndRunBinary() 
	:call vimspector#Reset()
	sleep 50m
	!cargo test --no-run
	let directory_root = trim(system("git rev-parse --show-toplevel"))
	let basename = trim(system("basename " . directory_root))
	let test_binary = trim(system('find ' . directory_root . '/target/debug/deps/ -name  "' . basename . '*" -executable -exec ls -1rt "{}" +| tail -n 1'))
	call vimspector#LaunchWithSettings( { 'configuration': 'Test', 'programName': test_binary } )
endfunction


nnoremap zR :call <SID>VimspectorBuildAndRunBinary()<CR>


nnoremap zr :call <SID>VimspectorCustomReset()<CR>

nnoremap zb :call vimspector#ToggleBreakpoint()<bar>:set scl=yes<CR>
nnoremap zt :call vimspector#RunToCursor()<CR>
nnoremap zz :call vimspector#Reset()<bar>:set scl=no<bar>set eventignore=""<CR>
nnoremap zB :call vimspector#ClearBreakpoints()<CR>
nmap zK <Plug>VimspectorBalloonEval
let g:vimspector_sidebar_width = 40
function! s:CustomiseUI()
  call win_gotoid( g:vimspector_session_windows.output )
  q
	set scl=yes
endfunction
let g:vimspector_variables_display_mode = 'full'



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

nmap zi <Plug>VimspectorBalloonEval
xmap zi <Plug>VimspectorBalloonEval
nnoremap J gJ
vnoremap J gJ

vnoremap <C-a> :<C-f>oChatGPTEditWithInstructions<CR>

"if exists('g:vscode')
"	call VSCodeExtensionNotify('open-file', MruGetFiles()[0])
"endif
