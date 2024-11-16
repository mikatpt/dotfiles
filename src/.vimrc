let mapleader =" "
inoremap <silent> jk <ESC>

inoremap <silent> jk            <ESC>
nnoremap <silent> Y             y$
nnoremap <silent> Q             @@
nnoremap <silent> <F1>          <nop>

" terminal bindings for command line mode
cnoremap <C-A>         <Home>
cnoremap <C-E>         <End>
cnoremap <C-B>         <Left>
cnoremap <C-F>         <Right>
set cedit=<C-G>

let abbreviations = {'qq': 'q', 'QQ': 'q', 'Qq': 'q', 'Q': 'q', 'qqa': 'qa', 'QQa': 'qa', 'Qqa': 'qa', 'W': 'w', 'Wq': 'wq', 'Wqa': 'wqa'}

for [wrong, right] in items(abbreviations)
  execute 'cnoreabbrev ' . wrong . ' ' . right
endfor

" Merge lines
nnoremap <S-M>         <S-J>

" Use J and K to move lines up and down.
nnoremap <silent> <S-K>         :m .-2<CR>==
nnoremap <silent> <S-J>         :m .+1<CR>==
vnoremap <silent> J :m '>+1<CR>gv=gv
vnoremap <silent> K :m '<-2<CR>gv=gv

" Indenting won't throw you out of visual mode
vnoremap <silent> <LT>          <LT>gv
vnoremap <silent> >             >gv

" Fix ctrl backspace behavior
map! <C-BS>       <C-W>
map! <C-H>        <C-W>

nnoremap <silent> <S-LEFT>      :vert res -5<CR>
nnoremap <silent> <S-RIGHT>     :vert res +5<CR>
nnoremap <silent> <S-UP>        :res +5<CR>
nnoremap <silent> <S-DOWN>      :res -5<CR>

" Use space j or k to open new splits, and Ctrl hjkl to move between them.
nnoremap <leader>j     :split<CR>
nnoremap <leader>k     :vsp<CR>
nnoremap <leader>u     :sp<CR>
nnoremap <leader><S-J> :topleft vsp<CR>
nnoremap <leader><S-K> :vsp<CR>
nnoremap <silent> <C-J>         <C-W><S-W>
nnoremap <silent> <C-K>         <C-W>w
nnoremap <silent> <C-H>         <C-W>h
nnoremap <silent> <C-L>         <C-W>l

" set current working directory to current file
nnoremap <leader>cd    :cd %:p:h<CR>

" Toggle relative/absolute line numbers
nnoremap <leader>l     :set rnu!<CR>

" Yank to system clipboard
nnoremap <leader>y     "+y
vnoremap <leader>y     "+y
nnoremap <leader><S-Y> <CMD>%y+<CR>

colo elflord
set noerrorbells
set nohlsearch
set hidden
set termguicolors
set background=dark
syntax on
set cmdheight=1
set updatetime=300
set shortmess+=cas
set mouse+=ar
set timeoutlen=200
set wildmenu
set wildmode=longest:full,full
if has('win32') || has('win64')
    set shell=cmd.exe
else
    set shell=/bin/bash
endif
set formatoptions-=crot
set textwidth=100
set conceallevel=2
set fileformat=unix
set fillchars=eob:\ 

" Tabs
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

" Line Numbers and Error Column
set relativenumber
set number
set scrolloff=8
set signcolumn=yes

" File tree things
set noswapfile
set nobackup
set nowritebackup
set undodir=~./vim/undo-dir
set undofile
set incsearch
set splitright
set smartcase
set ignorecase
set completeopt=menuone,noselect
