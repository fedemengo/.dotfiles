" note: weird charactes are generally Option + SYMBOL (on macOs)
" when moving to linux those mapping should be replaced with Alt

colorscheme PaperColor
set background=dark

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
set scrolloff=15
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

let mapleader = ";"

if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

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
    Plug 'williamboman/nvim-lsp-installer'
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
    Plug 'glepnir/dashboard-nvim'
" probably useless
    " learn vim
    Plug 'ThePrimeagen/vim-be-good'
    "git sheit
    Plug 'tpope/vim-fugitive'
    Plug 'rbong/vim-flog'
    Plug 'tpope/vim-rhubarb'
    Plug 'tveskag/nvim-blame-line'
    "probably cool if I learn how to use
    Plug 'wbthomason/packer.nvim'
    " dude
    Plug 'easymotion/vim-easymotion'
call plug#end()
" ------------------ PLUGINS END -------------------

" -------------- GLOBAL CONFIG START ---------------
let g:go_fmt_command = "goimports"
let g:tagbar_width = 50
let g:loaded_ruby_provider = 0
let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0
let g:go_def_mapping_enabled = 0
let g:dashboard_default_executive = 'telescope'
let g:dashboard_custom_header = ['','','','','','','','','','','']
let NERDTreeShowHidden = 1
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
            preview_height = 0.7,
        },
    },
    pickers = {
        find_files = {
            mappings = {
                -- not working - HELP
                n = {
                    ["cd"] = function(prompt_bufnr)
                        local selection = require("telescope.actions.state")
                        print(vim.inspect(selection))
                        --local dir = vim.fn.fnamemodify(selection.path, ":p:h")
                        --require("telescope.actions").close(prompt_bufnr)
                        -- Depending on what you want put `cd`, `lcd`, `tcd`
                        --vim.cmd(string.format("silent lcd %s", dir))
                    end
                }
            }
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
    window = {
      completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = {
        ['<C-q>']     = cmp.mapping.scroll_docs(4),
        ['<C-n>']     = cmp.mapping.select_next_item(),
        ['<C-p>']     = cmp.mapping.select_prev_item(),
        ["<C-e>"]     = cmp.mapping.abort(),
        ["<C-y>"]     = cmp.mapping.confirm({select = false}),
        ["<C-Space>"] = cmp.mapping.complete(),
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
        {name = "cmdline"},
        {name = "path"},
    }
})

-- https://github.com/hrsh7th/cmp-nvim-lsp#setup
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

lsp_conf = require("lspconfig")
-- https://github.com/neovim/nvim-lspconfig/tree/master/lua/lspconfig/server_configurations
local servers = { "gopls", "clangd", "vimls", "bashls", "dockerls", "sumneko_lua" }
require("nvim-lsp-installer").setup({
    ensure_installed = servers,
    automatic_installation = true,
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗"
        }
    }
})

for _, lsp in pairs(servers) do
    lsp_conf[lsp].setup {
        on_attach = function(client, bufrn)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer = 0})
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer = 0})
            vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, {buffer = 0})
            vim.keymap.set("n", "[d", vim.diagnostic.goto_next, {buffer = 0})
            vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, {buffer = 0})
        end,
        capabilities = capabilities,
    }
end

--[[
local custom_lsp_attach = function(_, bufnr)
    print('LSP attached')
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

lsp_conf.yamlls.setup {
    settings = {
        yaml = {
            schemaStore = {
                url = "https://www.schemastore.org/api/json/catalog.json",
                enable = true,
            },
            schemas = {
                kubernetes = "/*.yaml",
            },
            schemaDownload = {
                enable = true
            },
            validate = true,
        },
    },
    on_attach = custom_lsp_attach
}
--]]

-- https://github.com/nvim-treesitter/nvim-treesitter#modules
require "nvim-treesitter.configs".setup {
    ensure_installed = {"go", "cpp", "vim", "bash", "lua", "yaml", "dockerfile"},
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
" option + s
map ß :call ToggleSpell()<CR>

let s:toggle_theme_default = 1
function! ToggleTheme()
    if s:toggle_theme_default
        set background=light
        let s:toggle_theme_default = 0
    else
        set background=dark
        let s:toggle_theme_default = 1
    endif
endfunction
" option + t
noremap † :call ToggleTheme()<CR>

if executable("open-web-commit")
function! CommitOnWeb()
    let l:path = expand("%:h")
    let l:file = expand("%:t")
    let l:line = line(".")
    silent execute '!open-web-commit' shellescape(l:path) shellescape(l:file) shellescape(l:line)
    let l:err = v:shell_error
    redraw
    if l:err == 1
        echo l:path . " is not a git repository"
    elseif l:err == 2
        echo l:path . "/" . l:file . ":" . l:line . " was never commited"
    else
        "ok
    end
endfunction
noremap <silent><leader>cu :call CommitOnWeb()<CR>
endif
" ---------------- FUNCS CONFIG END ----------------

" quick escape with jk
inoremap jk <ESC>
tnoremap jk <C-\><C-n>

" copy cursor buffer path and line to clipboard
noremap <silent><leader>fp :let @+=expand("%") . ':' . line(".")<CR>

" this is so fucking broken
"nmap <leader>ss :<C-u>SessionSave<CR>
"nmap <leader>sl :<C-u>SessionLoad<CR>

" ---------- [ Autocommands ] ----------
" delete empty space from the end of lines on every save
autocmd BufWritePre * :%s/\s\+$//e

" Automatic toggling between 'hybrid' and absolute line numbers
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

" autosource configuration file on write for vimrc and plugins
autocmd! BufWritePost $VIMRC source $VIMRC | echom "config sourced"
autocmd! BufWritePost $HOME/.dotfiles/.config/nvim/init.vim source $VIMRC | echom "config sourced"
" ---------- [ Autocommands ] ----------

map <leader>vrc :tabe $VIMRC<CR>

command! -nargs=1 PR G pr <args>
nnoremap <silent><leader>gb :G blame<CR>
nnoremap <silent>∫ :ToggleBlameLine<CR>
map <leader><leader> <Plug>(easymotion-prefix)

" command line
cnoremap <C-a> <C-b>
cnoremap <C-d> <C-Right><C-w><Del>
cnoremap <C-w> <C-Right>
cnoremap <C-b> <C-Left>

cabbrev tb tabnew
nnoremap <C-n> :tabnew<CR>:Dashboard<CR>
nnoremap ˜ :tabnew<CR>
nnoremap <C-s> :vsplit<CR>

" move between tags, mac sheit
nnoremap ¡ 1gt
nnoremap ™ 2gt
nnoremap £ 3gt
nnoremap ¢ 4gt
nnoremap ∞ 5gt
nnoremap § 6gt
nnoremap ¶ 7gt
nnoremap • 8gt
nnoremap ª 9gt

" quick movement between split windows CTRL + {h, j, k, l}
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" useless resizing i will never use
"noremap <silent> <C-r>h :vertical resize +5<CR>
"noremap <silent> <C-r>l :vertical resize -5<CR>
"noremap <silent> <C-r>j :resize +5<CR>
"noremap <silent> <C-r>k :resize -5<CR>

" Go to the start and end of the line easier
noremap H ^
noremap L $

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
vnoremap <C-j> :m '>+10<CR>gv=gv
vnoremap <C-k> :m '<-11<CR>gv=gv

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
"map <C-b> :b#<CR>

nnoremap <silent>gh           <cmd>lua require('telescope.builtin').help_tags()<CR>

nnoremap <silent>ff           <cmd>lua require('telescope.builtin').find_files()<CR>
nnoremap <silent>fg           <cmd>lua require('telescope.builtin').live_grep()<CR>
nnoremap <silent>fs           <cmd>lua require('telescope.builtin').grep_string()<CR>
nnoremap <silent>fb           <cmd>lua require('telescope.builtin').buffers()<CR>
nnoremap <silent>fc           <cmd>lua require('telescope.builtin').command_history()<CR>
nnoremap <silent>gr           <cmd>lua require('telescope.builtin').lsp_references()<CR>
nnoremap <silent>gi           <cmd>lua require('telescope.builtin').lsp_implementations()<CR>
nnoremap <silent>gc           <cmd>lua require('telescope.builtin').git_commits()<CR>
nnoremap <silent>gs           <cmd>lua require('telescope.builtin').git_status()<CR>
nnoremap <silent>gS           <cmd>lua require('telescope.builtin').git_stash()<CR>

nnoremap <silent>ge           <cmd>lua require('telescope.builtin').diagnostics()<CR>

nnoremap <silent><leader>cw   <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent><leader>ca   <cmd>lua vim.lsp.buf.code_action()<CR>
xmap     <silent><leader>ca   <cmd>lua vim.lsp.buf.range_code_action()<CR>

" ## GO
" vim-go, load workspace when opening go file in GOPATH
autocmd BufRead "$GOPATH/src/*/*.go" :GoGuruScope ...
" vim-go, run test
autocmd BufEnter *.go nmap <leader>t  <Plug>(go-test)
autocmd BufEnter *.go nmap <leader>tt <Plug>(go-test-func)
autocmd BufEnter *.go nmap <leader>tc  <Plug>(go-coverage-toggle)

" utils
vnoremap <leader>e64 c<C-r>=system('base64', @")<CR><ESC>
vnoremap <leader>d64 c<C-r>=system('base64 --decode', @")<CR><ESC>
" allow gf to open non-existent files
map gf :edit <cfile><CR>
" reselect visual selection after indenting
vnoremap < <gv
vnoremap > >gv
" Maintain the cursor position when yanking a visual selection
" http://ddrscott.github.io/blog/2016/yank-without-jank/
vnoremap y myy`y
vnoremap Y myY`y

