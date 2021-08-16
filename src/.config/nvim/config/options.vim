" Global variables
let g:netrw_browse_split=0
let g:netrw_liststyle = 4
let g:netrw_banner = 0
let g:netrw_winsize = 75
let g:vim_markdown_fenced_languages = ['html', 'python', 'go', 'bash=sh', 'javascript', 'typescript']
let g:vim_markdown_folding_disabled = 1

" Basic Editor Settings
set noerrorbells
set nohlsearch
set hidden
set termguicolors
syntax on
colo lucid
set background=dark
set cmdheight=2
set updatetime=300
set shortmess+=c
set timeoutlen=200
set wildmenu
set wildmode=longest:full,full
set shell=/bin/bash

" Tabs
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

" Line Numbers and Error Column
set relativenumber
set nu
set scrolloff=8
set signcolumn=yes

" File tree things
set noswapfile
set nobackup
set nowritebackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set splitright
set smartcase
set ignorecase
set completeopt=menuone,noselect

" Indent preferences
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
autocmd FileType typescript setlocal shiftwidth=2 tabstop=2
autocmd FileType javascriptreact setlocal shiftwidth=2 tabstop=2
autocmd FileType typescriptreact setlocal shiftwidth=2 tabstop=2
