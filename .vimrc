call plug#begin('~/.vim/plugged')

Plug 'rafi/awesome-vim-colorschemes'

"""""""""""""""""""""""""""""""""""
" C# Plugins
"""""""""""""""""""""""""""""""""""
Plug 'OmniSharp/omnisharp-vim'
Plug 'dense-analysis/ale'
Plug 'prabirshrestha/asyncomplete.vim'

call plug#end()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CONFIGURATIONS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set relativenumber				" Show the line number relative to the line with the cursor in front of each line.
set nowrap						" When on, lines longer than the width of the window will wrap and displaying continues on the next line.

set tabstop=4					" Number of spaces that a <Tab> in the file counts for.
set softtabstop=4				" Number of spaces that a <Tab> counts for while performing editing operations, like inserting a <Tab> or using <BS>.
set autoindent					" Copy indent from current line when starting a new line.
set noexpandtab					" Do not replace <TAB> with spaces.

set incsearch					" While typing a search command, show where the pattern, as it was typed so far, matches.  The matched string is highlighted.
set ignorecase smartcase		" If the 'ignorecase' option is on, the case of normal letters is ignored. 'smartcase' can be set to ignore case when the pattern contains lowercase letters only.

set nobackup					" "NOT" Make a backup before overwriting a file.  Leave it around after the file has been successfully written.
set nowritebackup				" "NOT" Make a backup before overwriting a file.

set backspace=indent,eol,start	" Allow backspacing over everthing in insert mode

set autoread					" When a file has been detected to have been changed outside of Vim and	it has not been changed inside of Vim, automatically read it again.

set termguicolors				" When on, uses highlight-guifg and highlight-guibg attributes in the terminal (thus using 24-bit color).
set background=dark				" Use a dark background.

set completeopt=menuone,noinsert,noselect,popuphidden
set completepopup=highlight:Pmenu,border:off


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGIN CONFIGURATIONS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
colorscheme gruvbox

let g:ale_linters = { 'cs': ['OmniSharp'] }

" Fix the autocomplete bindings
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

nmap <C-n> :ALENextWrap<CR>

augroup omnisharp_commands
  autocmd!

  " Show type information automatically when the cursor stops moving.
  " Note that the type is echoed to the Vim command line, and will overwrite
  " any other messages in this space including e.g. ALE linting messages.
  autocmd CursorHold *.cs OmniSharpTypeLookup

  " The following commands are contextual, based on the cursor position.
  autocmd FileType cs nmap <silent> <buffer> gd <Plug>(omnisharp_go_to_definition)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfu <Plug>(omnisharp_find_usages)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfi <Plug>(omnisharp_find_implementations)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ospd <Plug>(omnisharp_preview_definition)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ospi <Plug>(omnisharp_preview_implementations)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ost <Plug>(omnisharp_type_lookup)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osd <Plug>(omnisharp_documentation)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfs <Plug>(omnisharp_find_symbol)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfx <Plug>(omnisharp_fix_usings)
  autocmd FileType cs nmap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)
  autocmd FileType cs imap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)

  " Navigate up and down by method/property/field
  autocmd FileType cs nmap <silent> <buffer> [[ <Plug>(omnisharp_navigate_up)
  autocmd FileType cs nmap <silent> <buffer> ]] <Plug>(omnisharp_navigate_down)
  " Find all code errors/warnings for the current solution and populate the quickfix window
  autocmd FileType cs nmap <silent> <buffer> <Leader>osgcc <Plug>(omnisharp_global_code_check)
  " Contextual code actions (uses fzf, vim-clap, CtrlP or unite.vim selector when available)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osca <Plug>(omnisharp_code_actions)
  autocmd FileType cs xmap <silent> <buffer> <Leader>osca <Plug>(omnisharp_code_actions)
  " Repeat the last code action performed (does not use a selector)
  autocmd FileType cs nmap <silent> <buffer> <Leader>os. <Plug>(omnisharp_code_action_repeat)
  autocmd FileType cs xmap <silent> <buffer> <Leader>os. <Plug>(omnisharp_code_action_repeat)

  autocmd FileType cs nmap <silent> <buffer> <Leader>os= <Plug>(omnisharp_code_format)

  autocmd FileType cs nmap <silent> <buffer> <Leader>osnm <Plug>(omnisharp_rename)

  autocmd FileType cs nmap <silent> <buffer> <Leader>osre <Plug>(omnisharp_restart_server)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osst <Plug>(omnisharp_start_server)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ossp <Plug>(omnisharp_stop_server)

  autocmd BufWritePost *.cs OmniSharpCodeFormat 
augroup END
