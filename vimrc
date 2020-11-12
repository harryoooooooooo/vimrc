set shell=/bin/bash

set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'majutsushi/tagbar'
Plugin 'mhinz/vim-signify'
Plugin 'tpope/vim-fugitive'
Plugin 'ycm-core/YouCompleteMe'
Plugin 'SirVer/ultisnips'
Plugin 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}
Plugin 'Yggdroot/indentLine'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'tommcdo/vim-exchange'
Plugin 'neovimhaskell/haskell-vim'
Plugin 'dag/vim-fish'
Plugin 'fatih/vim-go'
Plugin 'udalov/kotlin-vim'
Plugin 'rust-lang/rust.vim'
call vundle#end()
filetype plugin indent on

set expandtab shiftwidth=2 softtabstop=2 tabstop=2
set laststatus=2 noshowmode
set foldmethod=syntax foldlevelstart=99
set number relativenumber
set cursorline cursorlineopt=number
set nohlsearch incsearch
set timeoutlen=100 ttimeoutlen=100
set completeopt=""
set wildmenu
set background=dark
set updatetime=100
set vb t_vb=
set list listchars=tab:¦\ 
autocmd FileType qf setlocal nowrap
syntax on

function! SetTab(et, len)
  let &l:expandtab   = a:et
  let &l:shiftwidth  = a:len
  let &l:softtabstop = a:len
  let &l:tabstop     = a:len
endfunction
autocmd FileType python call SetTab(1, 2)
autocmd FileType go     call SetTab(0, 2)

colorscheme Tomorrow-Night-Bright
hi ExtraWhitespace ctermbg=darkgray
hi Normal ctermbg=NONE
hi LineNr ctermfg=gray
hi CursorLine ctermbg=NONE
hi CursorLineNr cterm=NONE ctermfg=black ctermbg=darkgray
hi OverLength ctermbg=darkgray

autocmd FileType gitcommit match OverLength /\%73v.\+/
autocmd FileType sql       match OverLength /\%101v.\+/
autocmd FileType python    match OverLength /\%81v.\+/
autocmd FileType cpp       match OverLength /\%81v.\+/

let g:exchange_no_mappings = 1

let g:ycm_show_diagnostics_ui = 0
let g:ycm_complete_in_comments = 1
let g:ycm_key_list_select_completion = ['<Down>']
let g:ycm_key_list_previous_completion = ['<Up>']
let g:ycm_auto_hover = ''

autocmd FileType tagbar call tagbar#StopAutoUpdate()

let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<s-tab>'

let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords
let g:haskell_indent_if = 4
let g:haskell_indent_case = 4
let g:haskell_indent_let = 4
let g:haskell_indent_where = 6
let g:haskell_indent_before_where = 2
let g:haskell_indent_after_bare_where = 2
let g:haskell_indent_do = 4
let g:haskell_indent_in = 0
let g:haskell_indent_guard = 4

let g:rustfmt_autosave = 1

function! Sudowrite()
  exe 'w ! sudo tee' shellescape('%') '> /dev/null'
  edit!
endfunction
command W call Sudowrite()

function! MakeLocList(comm, ...)
  let errorformat = &g:errorformat
  let &g:errorformat = get(a:, 1, &g:errorformat)
  exe 'lexpr system(a:comm) " a:comm =' a:comm
  let &g:errorformat = errorformat
endfunction

" Grep/Ag searches pat in all files recursively under CWD.
" grep/ag style parameters are passed to exe_name.
" Optional parameters can be passed as the third argument:
"   i => ignore case; by default case sensitive
"   w => do not search for a whole word; by default search for a whole word
"   h => search only files with suffix '.h'; by default all files
function! Grep(exe_name, pat, ...)
  let args = get(a:, 1, '')
  let comm = a:exe_name.' -nr'
  let pat = a:pat

  if stridx(args, 'w') == -1
    let pat = '\b'.pat.'\b'
  endif
  if stridx(args, 'i') != -1
    let comm = comm.' -i'
  endif
  if stridx(args, 'h') != -1
    let comm = comm.' --include='.shellescape('*.h')
  endif
  call MakeLocList(comm.' -- '.shellescape(pat), '%f:%l:%m')
endfunction
function! Ag(exe_name, pat, ...)
  let args = get(a:, 1, '')
  let comm = a:exe_name.' --vimgrep'
  let pat = a:pat

  if stridx(args, 'w') == -1
    let comm = comm.' -w'
  endif
  if stridx(args, 'i') != -1
    let comm = comm.' -i'
  else
    let comm = comm.' -s'
  endif
  if stridx(args, 'h') != -1
    let comm = comm.' -G '.shellescape('\.h$')
  endif
  call MakeLocList(comm.' -- '.shellescape(pat), '%f:%l:%c:%m')
endfunction

" Find/Fd searches files path matching pat recursively under CWD.
" find/fd style parameters are passed to exe_name.
" Optional parameters can be passed as the third argument:
"   d => search directory only; by default file only
function! Find(exe_name, pat, ...)
  let args = get(a:, 1, '')
  let comm = a:exe_name
  let pat = a:pat

  if stridx(args, 'd') == -1
    let comm = comm.' -type f'
  else
    let comm = comm.' -type d'
  endif
  call MakeLocList(comm.' -ipath '.shellescape('*'.pat.'*'), '%f')
endfunction
function! Fd(exe_name, pat, ...)
  let args = get(a:, 1, '')
  let comm = a:exe_name.' -p'
  let pat = a:pat

  if stridx(args, 'd') == -1
    let comm = comm.' -tf'
  else
    let comm = comm.' -td'
  endif
  call MakeLocList(comm.' -- '.shellescape(pat), '%f')
endfunction

" Prefer using ag than grep.
if exepath('ag') != ""
  command -nargs=+ Grep call Ag('ag', <f-args>) | lopen
elseif exepath('grep') != ""
  command -nargs=+ Grep call Grep('grep', <f-args>) | lopen
else
  command -nargs=* Grep echo 'No valid executable for Grep'
endif

" Prefer using fd/fdfind than find.
if exepath('fd') != ""
  command -nargs=+ Find call Fd('fd', <f-args>)
elseif exepath('fdfind') != ""
  command -nargs=+ Find call Fd('fdfind', <f-args>)
elseif exepath('find') != ""
  command -nargs=+ Find call Find('find', <f-args>)
else
  command -nargs=* Find echo 'No valid executable for Find'
endif

nnoremap Y y$
nnoremap <F3> :tabnew <bar> Grep <C-r><C-w><CR>
vnoremap <F3> "fy:tabnew <bar> Grep <C-r>f<CR>
vmap <F4> <Plug>(Exchange)
nmap <F4> <Plug>(ExchangeClear)
nnoremap <F5> :NERDTreeToggle <CR>
nnoremap <F6> :TagbarToggle <CR>
nmap <F7> <plug>(YCMHover)
