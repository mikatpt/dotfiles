" Global variables
let g:netrw_browse_split=0
let g:netrw_liststyle = 4
let g:netrw_banner = 0
let g:netrw_winsize = 75
let g:vim_markdown_fenced_languages = ['html', 'python', 'go', 'bash=sh', 'javascript', 'typescript']
let g:vim_markdown_folding_disabled = 1
let g:fugitive_github_domains = ['github.com', 'github.cbhq.net']
let g:vsnip_snippet_dir = "~/config/src/.config/nvim/snippets"
let g:vsnip_filetypes = {}
let g:vsnip_filetypes.javascriptreact = ['javascript']
let g:vsnip_filetypes.typescriptreact = ['javascript']
let g:vsnip_filetypes.typescript = ['javascript']

" This is to fix a neovim render bug in indent-blankline.
set colorcolumn=9999

" Basic Editor Settings
set noerrorbells
set nohlsearch
set hidden
set termguicolors
syntax on
colo lucid_nvim
set background=dark
set cmdheight=1
set updatetime=300
set shortmess+=ca
set timeoutlen=200
set wildmenu
set wildmode=longest:full,full
set shell=/bin/bash
set formatoptions-=cro
set conceallevel=2
" set list
" set listchars=lead:.

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
set undodir=~/.local/share/nvim/undodir
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
