" search down into subfolder
" tabl-completion for all file-related tasks
" ** (two star) 
set path+=**

" no compatibility with vi
set nocompatible

" command line autocompletion
set wildmenu

set shellslash
set grepprg=grep\ -nH\ $*
set number
set autoindent
set tabstop=4
set shiftwidth=4
set showmode
set autoindent
set ruler
set shortmess=atI
set title
set ttyfast
set cursorline
set ignorecase
set hlsearch
set incsearch
set scrolloff=10
set backspace=indent,eol,start

colorscheme onedark

syntax enable

filetype plugin indent on

" remove warning
if has('python3')
	silent! python3 1
endif

call plug#begin()
Plug 'ipod825/vim-netranger'
call plug#end()

" netranger
let g:NETRColors = {'dir': 039, 'cwd': 009, 'exe': 082}

hi Normal ctermbg=NONE

