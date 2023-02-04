" note: weird charactes are generally Option + SYMBOL (on macOs)
" when moving to linux those mapping should be replaced with Alt

" search subdirs
set path+=**
" command line autocompletion
set wildmode=longest,list,full
"done set wildmenu
set grepprg=grep\ -nH\ $*
"done set number
"done set autoread
"done set autoindent
"done set autowrite
"set autochdir breaks tree sitter
"done set showmode
"done set showcmd
"done set ruler
set shortmess=atI
"done set title
"done set cursorline
"done set ignorecase
"done set smartcase
"done set hlsearch
"done set incsearch
"done set scrolloff=15
set backspace=indent,eol,start
"done set expandtab
"done set tabstop=4
"done set shiftwidth=4
set linebreak
"done set spell spelllang=en_us
set spellcapcheck=
"done set splitbelow splitright
set noerrorbells
"done set noswapfile
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set nofoldenable
"done set timeoutlen=200 "timeout len used by which-key
"done set updatetime=200
filetype plugin indent on

"done let undodir_path = $HOME.'/.nvim/undo-dir'
"done if !isdirectory(undodir_path)
"done     call mkdir(undodir_path, 'p')
"done endif
"done 
"done let &undodir=undodir_path
"done set undofile

"done let mapleader = ";"

"done if has("autocmd")
"done     autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
"done endif

" ----------------- PLUGINS START ------------------
" Bootstrap Plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.config/nvim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $VIMRC
endif
unlet data_dir

" Run PlugInstall if there are missing plugins
"disalble autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
"disalble   \|    PlugInstall --sync | source $VIMRC
"disalble   \| else
"disalble "  \|    PlugClean | bd
"disalble   \|    echom "plugins are synced"
"disalble   \| endif
"disalble 
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
    Plug 'nvim-telescope/telescope-live-grep-raw.nvim'
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
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/vim-vsnip'
    Plug 'onsails/lspkind-nvim'         " symbols inside autocomplete menu options
" misc
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'mhinz/vim-startify'
    Plug 'junegunn/vim-peekaboo'
    Plug 'kevinhwang91/nvim-hlslens'
    Plug 'jdhao/better-escape.vim'
    Plug 'folke/which-key.nvim'
" probably useless
    " learn vim
    Plug 'ThePrimeagen/vim-be-good'
    "git sheit
    Plug 'tpope/vim-fugitive'
    Plug 'rbong/vim-flog'
    Plug 'tpope/vim-rhubarb'
    Plug 'rhysd/conflict-marker.vim'
    Plug 'lewis6991/gitsigns.nvim'
    "probably cool if I learn how to use
    Plug 'wbthomason/packer.nvim'
    " dude
    Plug 'easymotion/vim-easymotion'
    Plug 'morhetz/gruvbox'
call plug#end()
" ------------------ PLUGINS END -------------------

colorscheme PaperColor
"colorscheme gruvbox
set background=dark
"set background=light
" -------------- GLOBAL CONFIG START ---------------
let g:go_fmt_command = "goimports"
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_gopls_enabled = 0

let g:tagbar_width = 50
let g:loaded_ruby_provider = 0
let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0
let g:go_def_mapping_enabled = 0
let NERDTreeShowHidden = 1
let g:startify_bookmarks = systemlist("cut -sd' ' -f 2- ~/.NERDTreeBookmarks")
let g:startify_session_sort = 1
"let g:startify_bookmarks = systemlist("awk 'NF {print $2 \" \" NR-1}' ~/.NERDTreeBookmarks")
let g:better_escape_shortcut = 'jk'
let g:better_escape_interval = 200
let g:blameLineVerbose = 0

let g:conflict_marker_highlight_group = 'Error'
let g:conflict_marker_begin = '^<<<<<<< .*$'
let g:conflict_marker_end   = '^>>>>>>> .*$'

highlight ConflictMarkerBegin ctermbg=34
highlight ConflictMarkerOurs ctermbg=22
highlight ConflictMarkerTheirs ctermbg=23
highlight ConflictMarkerEnd ctermbg=39
" --------------- GLOBAL CONFIG END ----------------

" ---------------- LUA CONFIG START ----------------
lua <<EOF
require('gitsigns').setup({
    signs = {
        add          = {hl = 'GitSignsAdd'   , text = '+', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
        change       = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
        delete       = {hl = 'GitSignsDelete', text = '-', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
        topdelete    = {hl = 'GitSignsDelete', text = '-', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
        changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    },
    current_line_blame = false,
    current_line_blame_formatter = '<author> | <author_time:%a %d/%m/%y %X> | <summary>',
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 100,
        ignore_whitespace = false,
    }
})
-- https://github.com/folke/which-key.nvim
require("which-key").setup({})

-- https://github.com/nvim-telescope/telescope-fzf-native.nvim#telescope-setup-and-configuration
local action_state = require("telescope.actions.state")
local telescope = require('telescope')
telescope.load_extension('live_grep_raw')
telescope.load_extension('fzf')
telescope.setup({
    defaults = {
        layout_strategy = 'vertical',
        layout_config = {
            width = 0.95,
            height = 0.95,
            preview_height = 0.68,
        },
        file_ignore_patterns = {
          '.git/', 'node_modules/', '.npm/', '*[Cc]ache/', '*-cache*',
          '*.tags*', '*.gemtags*', '*.csv', '*.tsv', '*.tmp*',
          '*.old', '*.plist', '*.jpg', '*.jpeg', '*.png',
          '*.tar.gz', '*.tar', '*.zip', '*.class', '*.pdb', '*.dll',
          '*.dat', '*.mca', '__pycache__', '.mozilla/', '.electron/',
          '.vpython-root/', '.gradle/', '.nuget/', '.cargo/',
          'yay/', '.local/share/Trash/',
          '.local/share/nvim/swap/', 'code%-other/'
        },
    },
    pickers = {
        find_files = {
            mappings = {
                n = {
                    ["cd"] = function(prompt_bufnr, map)
                        local line = action_state.get_current_line()
                        if line ~= "" then
                            local dir = vim.fn.fnamemodify(line, ":p:h")
                            local val = vim.fn.input("cd to '" .. dir .. "' ? [y/n]")
                            if val == "y" or val == "Y" then
                                -- Depending on what you want put `cd`, `lcd`, `tcd`
                                vim.cmd(string.format("lcd %s", dir))
                            end
                        end
                        vim.cmd("echo ''")
                        --require("telescope.actions").close(prompt_bufnr)
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
        },
        live_grep_raw = {
          auto_quoting = false, -- enable/disable auto-quoting
        }
    }
})

vim.opt.completeopt={"menu", "menuone", "noselect", "noinsert"}
vim.opt.listchars = {tab = '▸ ', space = '⋅', eol = '↵'}
vim.opt.list = true
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
      documentation = cmp.config.window.bordered(),
    },
    mapping = {
        ['<C-q>']     = cmp.mapping.scroll_docs(4),
        ['<C-w>']     = cmp.mapping.scroll_docs(-4),
        ['<C-n>']     = cmp.mapping.select_next_item(),
        ['<C-p>']     = cmp.mapping.select_prev_item(),
        ["<C-e>"]     = cmp.mapping.abort(),
        ["<C-y>"]     = cmp.mapping.confirm({select = false}),
        ["<C-Space>"] = cmp.mapping.complete(),
    },
    sources = {
        {name = "nvim_lsp"},
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
            menu = {
                buffer = '[buf]',
                nvim_lsp = '[LSP]',
                path = '[path]',
                luasnip = '[snip]',
            },
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

function on_attach(client, bufrn)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer = bufrn})
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer = bufnr})
    vim.keymap.set("n", "td", vim.lsp.buf.type_definition, {buffer = bufnr})
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {buffer = bufnr})
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {buffer = bufnr})
end

lsp_conf = require("lspconfig")
lsp_util = require("lspconfig/util")
-- https://github.com/neovim/nvim-lspconfig/tree/master/lua/lspconfig/server_configurations
--local servers = {}
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
    if lsp == "gopls" then
        lsp_conf.gopls.setup({
            cmd = {"gopls", "serve"},
            filetypes = {"go", "gomod"},
            root_dir = lsp_util.root_pattern("go.work", "go.mod", ".git"),
            settings = {
                gopls = {
                    usePlaceholders = true,
                    buildFlags =  {"-tags=integration"},
                    gofumpt = true,
                    experimentalPostfixCompletions = true,
                    analyses = {
                        nilness = true,
                        unusedparams = true,
                        unusedwrite = true,
                        useany = true,
                        fillstruct = false,
                    },
                    codelenses = {
                        gc_details = true,
                        generate = true,
                        test = true,
                     },
                     staticcheck = true,
                     usePlaceholders = true,
                     experimentalUseInvalidMetadata = true,
                },
            },
            on_attach = on_attach,
            capabilities = capabilities,
            autostart = true,
        })
    else
        lsp_conf[lsp].setup({
        on_attach = on_attach,
        capabilities = capabilities,
    })
    end
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

require('neoscroll.config').set_mappings({
    ['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', '250'}},
    ['<C-d>'] = {'scroll', { 'vim.wo.scroll', 'true', '250'}},
    ['<C-y>'] = {'scroll', {'-0.10', 'false', '100'}},
    ['<C-e>'] = {'scroll', { '0.10', 'false', '100'}},
})

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

function! s:gitModified()
    let files = systemlist('git ls-files -m 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

" same as above, but show untracked files, honouring .gitignore
function! s:gitUntracked()
    let files = systemlist('git ls-files -o --exclude-standard 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

let g:startify_lists = [
    \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
    \ { 'type': 'sessions',  'header': ['   Sessions']       },
    \ { 'type': 'files',     'header': ['   MRU']            },
    \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
    \ { 'type': function('s:gitModified'),  'header': ['   git modified']},
    \ { 'type': function('s:gitUntracked'), 'header': ['   git untracked']},
    \ { 'type': 'commands',  'header': ['   Commands']       },
    \ ]

" https://github.com/junegunn/vim-peekaboo/issues/68
function! CreateCenteredFloatingWindow() abort
    if(!has('nvim'))
        split
        new
    else
        let width = float2nr(&columns * 0.7)
        let height = float2nr(&lines * 0.7)
        let top = ((&lines - height) / 2) - 1
        let left = (&columns - width) / 2
        let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}
        let s:buf = nvim_create_buf(v:false, v:true)
        call nvim_open_win(s:buf, v:true, opts)
    endif
endfunction

let g:peekaboo_window="call CreateCenteredFloatingWindow()"

if exists("+showtabline")
    function! NumberedTabLine()
        let s = ''
        let wn = ''
        let t = tabpagenr()
        let i = 1
        while i <= tabpagenr('$')
            let buflist = tabpagebuflist(i)
            let winnr = tabpagewinnr(i)
            let s .= '%' . i . 'T'
            let s .= (i == t ? '%1*' : '%2*')
            let s .= ' '
            let wn = tabpagewinnr(i,'$')

            let s .= '%#TabNum#'
            let s .= i . ':'
            " let s .= '%*'
            let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
            let bufnr = buflist[winnr - 1]
            let file = bufname(bufnr)
            let buftype = getbufvar(bufnr, 'buftype')
            if buftype == 'nofile'
                if file =~ '\/.'
                    let file = substitute(file, '.*\/\ze.', '', '')
                endif
            else
                let file = fnamemodify(file, ':p:t')
            endif
            if file == ''
                let file = '[No Name]'
            endif
            let s .= ' ' . file . ' '
            let i = i + 1
        endwhile
        let s .= '%T%#TabLineFill#%='
        let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
        return s
    endfunction
    set stal=2
    set tabline=%!NumberedTabLine()
    set showtabline=1
    highlight link TabNum Special
endif

let g:reopenbuf = expand('%:p')
function! ReopenLastTabLeave()
  let g:lastbuf = expand('%:p')
  let g:lasttabcount = tabpagenr('$')
endfunction

function! ReopenLastTabEnter()
  if tabpagenr('$') < g:lasttabcount
    let g:reopenbuf = g:lastbuf
  endif
endfunction

function! ReopenLastTab()
  tabnew
  execute 'buffer' . g:reopenbuf
endfunction
" ---------------- FUNCS CONFIG END ----------------

" quick escape with jk
inoremap jk <ESC>
tnoremap jk <C-\><C-n>

" copy cursor buffer path and line to clipboard
noremap <silent><leader>fp :let @+=expand("%:p") . ':' . line(".")<CR>

" this is so fucking broken
"nmap <leader>ss :<C-u>SessionSave<CR>
"nmap <leader>sl :<C-u>SessionLoad<CR>

" ---------- [ Autocommands ] ----------
" delete empty space from the end of lines on every save
autocmd BufWritePre * :%s/\s\+$//e

autocmd InsertLeave * if &readonly == 0 && filereadable(bufname('%')) | silent! update | endif

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

nnoremap <leader>fq :qa<CR>
map <leader>cf :tabe $VIMRC<CR>

" lcd to file's directory
nnoremap <leader>cd :lcd %:p:h<CR>: echo "cwd is now ".expand('%:p:h')<CR>
"nnoremap <leader>cd :lcd substitute(expand('%:p:h')a, 'NERD_tree_3', '', ''))<CR>: echo "cwd is now ".expand('%:p:h')<CR>

nnoremap <silent><leader>b :Git blame<CR>
" option+b
nnoremap <silent>∫ :Gitsigns toggle_current_line_blame<CR>
nnoremap <silent><leader>gs :Gitsigns toggle_signs<CR>

map s <Plug>(easymotion-prefix)

" option+h
map ˙ :noh<CR>

" command line
cnoremap <C-a> <C-b>
cnoremap <C-d> <C-Right><C-w><Del>
cnoremap <C-w> <C-Right>
cnoremap <C-b> <C-Left>

cabbrev tb tabnew
nnoremap <C-b> :tabnew <CR>:Startify<CR>
" open new file at current line in new tab
nnoremap <C-n> mt :tabe %<CR>`t
noremap <leader>h :tabmove -1<CR>
noremap <leader>l :tabmove +1<CR>

" tab restore
augroup ReopenLastTab
  autocmd!
  autocmd TabLeave * call ReopenLastTabLeave()
  autocmd TabEnter * call ReopenLastTabEnter()
augroup END
nnoremap <leader>tr :call ReopenLastTab()<CR>

nnoremap <leader>v :vsplit<CR>
nnoremap <leader>s :split<CR>
nnoremap <C-g> :echo expand('%:p')<CR>

" move between tabs, mac sheit
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
noremap <silent> <leader>rh :vertical resize +5<CR>
noremap <silent> <leader>rl :vertical resize -5<CR>
noremap <silent> <leader>rj :resize +5<CR>
noremap <silent> <leader>rk :resize -5<CR>

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

"nnoremap <silent>ff           <cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_ivy())<CR>
nnoremap <silent>ff           <cmd>lua require('telescope.builtin').find_files()<CR>
nnoremap <silent>fg           <cmd>lua require('telescope.builtin').live_grep()<CR>
nnoremap <silent>fz           <cmd>lua require('telescope.builtin').grep_string({shorten_path = true, only_sort_text = true, search = ''})<CR>
nnoremap <silent>fs           <cmd>lua require('telescope.builtin').grep_string()<CR>
nnoremap <silent>fb           <cmd>lua require('telescope.builtin').buffers()<CR>
nnoremap <silent>fc           <cmd>lua require('telescope.builtin').command_history()<CR>
nnoremap <silent>gr           <cmd>lua require('telescope.builtin').lsp_references()<CR>
nnoremap <silent>gi           <cmd>lua require('telescope.builtin').lsp_implementations()<CR>
nnoremap <silent>gc           <cmd>lua require('telescope.builtin').git_commits()<CR>
nnoremap <silent>gs           <cmd>lua require('telescope.builtin').git_status()<CR>
nnoremap <silent>gS           <cmd>lua require('telescope.builtin').git_stash()<CR>

nnoremap <silent>fe           <cmd>lua require('telescope.builtin').diagnostics()<CR>

nnoremap <silent>,pd :LspPeekDefinition<CR>
nnoremap <silent>,pi :LspPeekImplementation<CR>
nnoremap <silent>,pt :LspPeekTypeDefinition<CR>

nnoremap <silent><leader>cw   <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent><leader>ca   <cmd>lua vim.lsp.buf.code_action()<CR>
xmap     <silent><leader>ca   <cmd>lua vim.lsp.buf.range_code_action()<CR>

" ## GO
" vim-go, load workspace when opening go file in GOPATH
autocmd BufRead "$GOPATH/src/*/*.go" :GoGuruScope ...
" vim-go, run test
autocmd BufEnter *.go nmap <leader>t  <Plug>(go-test)
autocmd BufEnter *.go nmap <leader>tt <Plug>(go-test-func)
autocmd BufEnter *.go nmap <leader>tc <Plug>(go-coverage-toggle)

" ## UTILS
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

