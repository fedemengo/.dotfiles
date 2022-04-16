colorscheme PaperColor

" search subdirs
set path+=**
" no compatibility with vi
set nocompatible
" command line autocompletion
set wildmode=longest,list,full
set wildmenu
set grepprg=grep\ -nH\ $*
set number
set autoindent
set autowrite
set tabstop=4
set shiftwidth=4
set showmode
set showcmd
set ruler
set shortmess=atI
set title
set ttyfast " scroll fast
set cursorline
set ignorecase
set hlsearch
set incsearch
set scrolloff=20
set backspace=indent,eol,start
set expandtab
set linebreak
set list
set spell
set spellcapcheck=
set completeopt+=noinsert
set splitbelow splitright
filetype plugin indent on

if !isdirectory($HOME.'/.nvim/undo-dir')
  call mkdir($HOME.'/.nvim/undo-dir', 'p')
endif
set undodir=~/.nvim/undo-dir  " use undodir
set undofile

" ----------------- PLUGINS START ------------------
call plug#begin('~/.config/nvim/autoload/plugged')
" syntax highlight
    Plug 'sheerun/vim-polyglot'
    Plug 'elzr/vim-json'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" telescope and deps
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'numkil/ag.nvim'
" navigation and co
    Plug 'preservim/tagbar'
    Plug 'preservim/nerdtree'
    Plug 'jeffkreeftmeijer/vim-numbertoggle'
" go
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" lsp magic
    Plug 'neovim/nvim-lspconfig'
    Plug 'prabirshrestha/vim-lsp'
    Plug 'mattn/vim-lsp-settings'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/vim-vsnip'
    Plug 'hrsh7th/vim-vsnip-integ'
" probably useless
    " learn vim
    Plug 'ThePrimeagen/vim-be-good'
    "git sheit
    Plug 'tpope/vim-fugitive'
    Plug 'rbong/vim-flog'
    "probably cool if I learn how to use
    Plug 'wbthomason/packer.nvim'
call plug#end()
" ------------------ PLUGINS END -------------------

" -------------- GLOBAL CONFIG START ---------------
let g:PaperColor_Theme_Options = {
  \   'theme': {
  \     'default.dark': {
  \       'override' : {
  \         'spellbad' : ['#1c1c1c', '234'],
  \       }
  \     }
  \   }
  \ }

let g:go_fmt_command = "goimports"
"let g:deoplete#enable_at_startup = 1
let g:tagbar_width=50
let g:loaded_ruby_provider = 0
let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0
" --------------- GLOBAL CONFIG END ----------------

" ---------------- LUA CONFIG START ----------------
lua <<EOF
-- https://github.com/hrsh7th/nvim-cmp#setup
local cmp = require "cmp"

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        end
    },
    window = {},
    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({select = true}) -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        {name = "nvim_lsp"},
        {name = "vsnip"} -- For vsnip users.
    },{
        {name = "buffer"}
    })
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
        {name = "cmp_git"} -- You can specify the `cmp_git` source if you were installed it.
    },{
        {name = "buffer"}
    })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        {name = "buffer"}
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        {name = "path"}
    },{
        {name = "cmdline"}
    })
})

-- https://github.com/hrsh7th/cmp-nvim-lsp#setup
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

require "lspconfig".gopls.setup {
    capabilities = capabilities
}

-- https://github.com/nvim-treesitter/nvim-treesitter#modules
require "nvim-treesitter.configs".setup {
    ensure_installed = {"go"},
    sync_install = false,
    indent = {
        enable = true
    },
    highlight = {
        enable = false,
        additional_vim_regex_highlighting = false
    }
}
EOF
" ----------------- LUA CONFIG END -----------------

let mapleader = ","
" quick escape with jk
inoremap jk <Esc>
tnoremap jk <C-\><C-n>

" delete empty space from the end of lines on every save
autocmd BufWritePre * :%s/\s\+$//e

" autosource configuration file on write for vimrc and plugins
autocmd! BufWritePost $VIMRC source $VIMRC | echom "config sourced"
autocmd! BufWritePost $HOME/.dotfiles/.config/nvim/init.vim source $VIMRC | echom "config sourced"
map <leader>vrc :tabe $VIMRC

" quick movement between split windows CTRL + {h, j, k, l}
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" useless resizing i will never use
noremap <silent> <C-r>h :vertical resize +5<CR>
noremap <silent> <C-r>l :vertical resize -5<CR>
noremap <silent> <C-r>j :resize +5<CR>
noremap <silent> <C-r>k :resize -5<CR>

" disable Arrow keys in Normal mode
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" disable Arrow keys in Insert mode
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

" move text up/down in visual mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
vnoremap <C-J> :m '>+10<CR>gv=gv
vnoremap <C-K> :m '<-11<CR>gv=gv

" yank/paste to/from clipboard
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nmap <leader>Y "+Y
nnoremap <leader>p "+p
vnoremap <leader>p "+r
nmap <leader>P "+P

" accept popup menu entry with Enter without new line
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" ## NAVIGATION
"show minimap
nmap <leader>m :TagbarToggle<CR>
" nerdtree
noremap <leader>nn :NERDTreeToggle<CR>
" quickly go to prev buffer
map <C-b> :b#<CR>

nnoremap <silent>gh           <cmd>lua require('telescope.builtin').help_tags()<cr>

nnoremap <silent>ff           <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <silent>fg           <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <silent>fs           <cmd>lua require('telescope.builtin').grep_string()<cr>
nnoremap <silent>fb           <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <silent>gd           <cmd>lua require('telescope.builtin').lsp_definition()<CR>
nnoremap <silent>gi           <cmd>lua require('telescope.builtin').lsp_implementation()<CR>
nnoremap <silent>gr           <cmd>lua require('telescope.builtin').lsp_references()<CR>
nnoremap <silent>ge           <cmd>lua require('telescope.builtin').diagnostics()<CR>
nnoremap <silent><leader>c    <cmd>lua require('telescope.builtin').command_history()<cr>

nnoremap <silent>K            <cmd>lua vim.lsp.buf.hover()<CR> "document symbol
nnoremap <silent><leader>rn   <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <leader>a   <cmd>lua vim.lsp.buf.code_action()<CR>
xmap <silent> <leader>a       <cmd>lua vim.lsp.buf.range_code_action()<CR>

" ## GO
" vim-go, load workspace when opening go file in GOPATH
autocmd BufRead "$GOPATH/src/*/*.go" :GoGuruScope ...
" vim-go, run test
autocmd BufEnter *.go nmap <leader>t  <Plug>(go-test)
autocmd BufEnter *.go nmap <leader>tt <Plug>(go-test-func)
autocmd BufEnter *.go nmap <leader>tc  <Plug>(go-coverage-toggle)

" utils
vnoremap <leader>e64 c<c-r>=system('base64', @")<cr><esc>
vnoremap <leader>d64 c<c-r>=system('base64 --decode', @")<cr><esc>
