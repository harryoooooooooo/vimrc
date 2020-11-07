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

command -nargs=1 Find  call MakeLocList('find -type f -ipath '.shellescape('*'.<q-args>.'*'), '%f')
command -nargs=1 Findd call MakeLocList('find -type d -ipath '.shellescape('*'.<q-args>.'*'), '%f')
command -nargs=1 Grep  call  MakeLocList('grep -nr  '.shellescape('\b'.<q-args>.'\b'), '%f:%l:%m') | lopen
command -nargs=1 Grepi call  MakeLocList('grep -nri '.shellescape('\b'.<q-args>.'\b'), '%f:%l:%m') | lopen
command -nargs=1 Grepw  call MakeLocList('grep -nr  '.shellescape(<q-args>), '%f:%l:%m') | lopen
command -nargs=1 Grepwi call MakeLocList('grep -nri '.shellescape(<q-args>), '%f:%l:%m') | lopen

" Enable modern tools by calling these function, and may specify the binary name
" by passing it as parameter.
function! EnableFd(...)
  let g:fd_comm = get(a:, 1, 'fd')
  command! -nargs=1 Find  call MakeLocList(fd_comm.' -tf -p -- '.shellescape(<q-args>), '%f')
  command! -nargs=1 Findd call MakeLocList(fd_comm.' -td -p -- '.shellescape(<q-args>), '%f')
endfunction
function! EnableAg(...)
  let g:ag_comm = get(a:, 1, 'ag')
  command! -nargs=1 Grep  call MakeLocList(ag_comm.' -ws --vimgrep -- '.shellescape(<q-args>), '%f:%l:%c:%m') | lopen
  command! -nargs=1 Grepi call MakeLocList(ag_comm.' -wi --vimgrep -- '.shellescape(<q-args>), '%f:%l:%c:%m') | lopen
  command! -nargs=1 Grepw  call MakeLocList(ag_comm.' -s --vimgrep -- '.shellescape(<q-args>), '%f:%l:%c:%m') | lopen
  command! -nargs=1 Grepwi call MakeLocList(ag_comm.' -i --vimgrep -- '.shellescape(<q-args>), '%f:%l:%c:%m') | lopen
endfunction

if exepath('fd') != ""
  call EnableFd()
endif
if exepath('fdfind') != ""
  call EnableFd('fdfind')
endif
if exepath('ag') != ""
  call EnableAg()
endif

nnoremap Y y$
nnoremap <F3> :tabnew <bar> Grep <C-r><C-w><CR>
vnoremap <F3> "fy:tabnew <bar> Grep <C-r>f<CR>
vmap <F4> <Plug>(Exchange)
nmap <F4> <Plug>(ExchangeClear)
nnoremap <F5> :NERDTreeToggle <CR>
nnoremap <F6> :TagbarToggle <CR>
nmap <F7> <plug>(YCMHover)
