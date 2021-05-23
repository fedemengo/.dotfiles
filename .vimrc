" SETTINGS
"
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
set showcmd
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
set relativenumber

colorscheme onedark

if &t_Co > 1
	syntax enable
endif

filetype plugin indent on


" MAPPING
"
:map \" i"<Esc>ea"<Esc>
:map \p i(<Esc>ea)<Esc>
:map \c i{<Esc>ea}<Esc>


" PACKAGES
"
packadd! matchit


" NOTES
"
" TOhtml: generate html for the current file 
"
" Editing mupliple files: vim one.c two.c three.c
" 	- next to move to the next file
" 	- next! to move to the next file and discarding the changes
" 	- args to show in what file you're currently on
" 	- previous
" 	- last
" 	- 3next
" 	- set autowrite to write automatically when moving
" 	- args four.c five.c to change the list of arguments to edit
"
" Marks
" 	'" to move to the position the cursor was when last opened the file
" 	'. to move to the position where the last change was


" OTHERS
"
" remove warning
if has('python3')
	silent! python3 1
endif

"call plug#begin()
"Plug 'ipod825/vim-netranger'
"call plug#end()

" netranger
let g:NETRColors = {'dir': 039, 'cwd': 009, 'exe': 082}

hi Normal ctermbg=NONE

