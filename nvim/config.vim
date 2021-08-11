" Global variables
let mapleader = " "
let g:netrw_browse_split=2
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

" Vim Commentary - use gc to comment out lines. (no extra remap necessary)

" Rename variables (coc.nvim)
nmap <leader>r <Plug>(coc-rename)

" Find files (Telescope)
nnoremap <C-p> <cmd>Telescope find_files<CR>
nnoremap <leader>p <cmd>Telescope buffers<cr>
nnoremap <leader>f <cmd>Telescope grep_string<CR> 

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

