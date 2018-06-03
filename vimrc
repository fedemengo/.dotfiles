set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
"Plugin 'xuhdev/vim-latex-live-preview'
"Plugin 'JamshedVesuna/vim-markdown-preview'

call vundle#end()
filetype plugin indent on

set shellslash
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'

set gfn=Ubuntu\ Mono\ derivative\ Powerline:h16 

syntax on
colorscheme molokai
set number
"set wrapmargin=8
set autoindent
set tabstop=4
set shiftwidth=4
set showmode
set autoindent
set ruler
set shortmess=atI
set title
set ttyfast
set esckeys
set cursorline
set wildmenu
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
