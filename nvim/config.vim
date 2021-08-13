" Global variables
let mapleader = " "
let g:netrw_browse_split=0
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_winsize = 75
let g:vim_markdown_fenced_languages = ['html', 'python', 'go', 'bash=sh', 'javascript', 'typescript']
let g:vim_markdown_folding_disabled = 1

" Remappings
inoremap jk <esc>
nmap <silent>; :

" Fix ctrl backspace behavior
noremap! <C-BS> <C-w>
noremap! <C-h> <C-w>

" Fix vim Y behavior
nnoremap Y y$

" Use space J or K to open new splits, and Ctrl J K to move between them.
nnoremap <leader>j :topleft vsp<CR>
nnoremap <leader>k :vsp<CR>
nnoremap <leader><S-J> :topleft vsp<CR>
nnoremap <leader><S-K> :vsp<CR>
nnoremap <C-J> <C-W><S-W>
nnoremap <C-K> <C-W>w

" Use J and K to move lines up and down. 
nnoremap <S-J> :m .+1<CR>==
nnoremap <S-K> :m .-2<CR>==
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" From vim-commentary:
" gc to comment out lines

" From nvim-treesitter and lsp:
" <leader>s to format
" <leader>rn to rename a variable
" m to show hover definition
" gd to go to definition
" gD go to declaration
" gi go to implementation

" From nvim-dap
" F5 to debug
" F10 to step over 
" F11 to step into
" F12 to step out
" ctrl B to set breakpoint
" leader h to show current frame information

" Find files (Telescope)
nnoremap <C-p> <cmd>Telescope git_files<CR>
nnoremap <leader>p <cmd>Telescope find_files<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>f :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>
" Grep current word under cursor
nnoremap <leader>w :lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>

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

" Plugins
set completeopt=menuone,noselect
execute "source " . fnamemodify(home, ":p:H") . "config/nvim/plugins.vim"
execute "source " . fnamemodify(home, ":p:H") . "config/nvim/language/init.vim"
execute "source " . fnamemodify(home, ":p:H") . "config/nvim/language/keybindings.vim"
execute "source " . fnamemodify(home, ":p:H") . "config/nvim/debugging.vim"

