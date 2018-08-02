" no compatibility with vi
set nocompatible

" config for netrw
syntax enable
filetype plugin indent on

" remove warning
if has('python3')
	silent! python3 1
endif

" search down into subfolder
" tabl-completion for all file-related tasks
" ** (two star) 
set path+=**

call plug#begin()
Plug 'ipod825/vim-netranger'
call plug#end()

" netranger
let g:NETRColors = {'dir': 039, 'cwd': 009, 'exe': 082}

" command line autocompletion
set wildmenu

" map esc key
inoremap jj <Esc>

let g:netrw_banner=0
let g:netrw_browse_split=4
let g:netrw_altv=1
let g:nert_liststyle=3		" tree view

set shellslash
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'

set backspace=indent,eol,start
"set gfn=Ubuntu\ Mono\ derivative\ Powerline:h16 

colorscheme onedark
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
"set esckeys
set cursorline
set gdefault

set ignorecase
set hlsearch
set incsearch
set scrolloff=10

"let g:livepreview_previewer = 'open -a Preview'
"let g:livepreview_engine = '/Library/TeX/texbin/pdftex'
let vim_markdown_preview_hotkey='<C-p>'
let vim_markdown_preview_toggle=2
let vim_markdown_preview_github=1

"let g:loaded_logipat = 1


hi Normal ctermbg=NONE

