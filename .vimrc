" remove all existing autocmds
autocmd!

execute pathogen#infect()
syntax on
filetype plugin indent on

set nocompatible

" Don't make backups at all
set nobackup
set nowritebackup

set expandtab
set tabstop=2
set shiftwidth=4
set softtabstop=4
set autoindent
set laststatus=4
set showmatch
set incsearch
set hlsearch

set backspace=indent,eol,start

set wildmode=longest,list

set autoread

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>
