colorscheme PaperColor

" search subdirs
set path+=**
" command line autocompletion
set wildmode=longest,list,full
set wildmenu
set grepprg=grep\ -nH\ $*
set number
set autoindent
set autowrite
set showmode
set showcmd
set ruler
set shortmess=atI
set title
set cursorline
set ignorecase
set smartcase
set hlsearch
set incsearch
set scrolloff=999
set backspace=indent,eol,start
set expandtab
set tabstop=4
set shiftwidth=4
set linebreak
set list
set spell spelllang=en_us
set spellcapcheck=
set splitbelow splitright
set noerrorbells
set noswapfile
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set nofoldenable
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
    Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
" navigation and co
    Plug 'preservim/tagbar'
    Plug 'preservim/nerdtree'
    Plug 'jeffkreeftmeijer/vim-numbertoggle'
    Plug 'karb94/neoscroll.nvim'
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
    Plug 'L3MON4D3/LuaSnip'
    Plug 'onsails/lspkind-nvim'         " symbols inside autocomplete menu options
" misc
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'kyazdani42/nvim-web-devicons'
" probably useless
    " learn vim
    Plug 'ThePrimeagen/vim-be-good'
    "git sheit
    Plug 'tpope/vim-fugitive'
    Plug 'rbong/vim-flog'
    Plug 'tpope/vim-rhubarb'
    "probably cool if I learn how to use
    Plug 'wbthomason/packer.nvim'
    " dude
    Plug 'easymotion/vim-easymotion'
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
let g:tagbar_width=50
let g:loaded_ruby_provider = 0
let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0
let g:go_def_mapping_enabled=0
let NERDTreeShowHidden=1
" --------------- GLOBAL CONFIG END ----------------

" ---------------- LUA CONFIG START ----------------
lua <<EOF
-- https://github.com/nvim-telescope/telescope-fzf-native.nvim#telescope-setup-and-configuration
require('telescope').setup {
    defaults = {
        layout_strategy = 'vertical',
        layout_config = {
            width = 0.95,
            height = 0.95,
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
        }
    }
}
require('telescope').load_extension('fzf')

vim.opt.completeopt={"menu", "menuone", "noselect", "noinsert"}
-- https://github.com/hrsh7th/nvim-cmp#setup
local cmp = require("cmp")
local lspkind = require("lspkind")

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = {
        ['<C-N>'] = cmp.mapping(cmp.mapping.select_next_item()),
        ['<C-P>'] = cmp.mapping(cmp.mapping.select_prev_item()),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-E>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({select = true}), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = {
        {name = "nvim_lsp"},
        {name = "nvim_lua"},
        {name = "path"},
        {name = "luasnip"},
        {name = "buffer", keyword_legth = 3 },
    },
    experimental = {
          native_menu = false,
          ghost_text = true
    },
    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol_text',
            maxwidth = 50,
        }),
    },
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
    sources = {
        {name = "path"},
        {name = "cmdline"},
    }
})

-- https://github.com/hrsh7th/cmp-nvim-lsp#setup
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

require "lspconfig".gopls.setup {
    on_attach = function()
        vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer = 0})
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer = 0})
        vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, {buffer = 0})
        vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", {buffer = 0})
        vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, {buffer = 0})
        vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, {buffer = 0})
    end,
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
        enable = true,
        additional_vim_regex_highlighting = false
    }
}

-- https://github.com/karb94/neoscroll.nvim
require('neoscroll').setup({
    -- Set any options as needed
})
local t = {}
t['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', '250'}}
t['<C-d>'] = {'scroll', { 'vim.wo.scroll', 'true', '250'}}
t['<C-y>'] = {'scroll', {'-0.10', 'false', '100'}}
t['<C-e>'] = {'scroll', { '0.10', 'false', '100'}}
require('neoscroll.config').set_mappings(t)

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'ayu_mirage',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = false,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff'},
    lualine_c = {
        {'diagnostics',
            sources = { 'nvim_diagnostic', 'vim_lsp' },
            colored = true,
            diagnostic_color = {
                error = { fg = '#ff0000'},
            },
        }
    },
    lualine_x = {'filename', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  tabline = {},
  extensions = {}
}
EOF
" ----------------- LUA CONFIG END -----------------
" --------------- FUNCS CONFIG START ---------------
hi clear SpellBad
hi clear SpellCap
hi clear SpellRare
hi clear SpellLocal

function! ToggleSpell()
    if !exists("g:showingSpell")
        let g:showingSpell=0
      endif

    if g:showingSpell==0
        execute "hi SpellBad cterm=underline ctermfg=red"
        let g:showingSpell=1
   else
        execute "hi clear SpellBad"
        let g:showingSpell=0
   endif
endfunction
map <leader>sp :call ToggleSpell()<CR>

" ---------------- FUNCS CONFIG END ----------------

let mapleader = ";"
" quick escape with jk
inoremap jk <Esc>
tnoremap jk <C-\><C-n>
" copy buffer path to clipboard
noremap <leader>fp :!echo % \| pbcopy<CR><CR>

" delete empty space from the end of lines on every save
autocmd BufWritePre * :%s/\s\+$//e

" autosource configuration file on write for vimrc and plugins
autocmd! BufWritePost $VIMRC source $VIMRC | echom "config sourced"
autocmd! BufWritePost $HOME/.dotfiles/.config/nvim/init.vim source $VIMRC | echom "config sourced"
map <leader>vrc :tabe $VIMRC<CR>

" command line
cnoremap <C-A> <C-B>
cnoremap <C-D> <C-Right><C-W><Del>
cnoremap <C-W> <C-Right>
cnoremap <C-B> <C-Left>

cabbrev tb tabnew

nnoremap <C-N> :tabnew<CR>
nnoremap <C-S> :vsplit<CR>

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
xnoremap <leader>p "_dP

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
nnoremap <silent>gr           <cmd>lua require('telescope.builtin').lsp_references()<CR>
"nnoremap <silent>pd           :LspPeekDefinition<CR>
nnoremap <silent>ge           <cmd>lua require('telescope.builtin').diagnostics()<CR>
nnoremap <silent><leader>c    <cmd>lua require('telescope.builtin').command_history()<cr>

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
" allow gf to open non-existent files
map gf :edit <cfile><cr>
" reselect visual selection after indenting
vnoremap < <gv
vnoremap > >gv
" Maintain the cursor position when yanking a visual selection
" http://ddrscott.github.io/blog/2016/yank-without-jank/
vnoremap y myy`y
vnoremap Y myY`y
