set incsearch
set smartcase
set ignorecase
set formatoptions-=cro
nnoremap <Space> :noh<CR>

nnoremap m <Cmd>call VSCodeNotify('editor.action.showHover')<CR>
xmap gc <Plug>VSCodeCommentary
nmap gc <Plug>VSCodeCommentary
omap gc <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentary

" Use J and K to move lines up and down.
nnoremap <S-J> :m .+1<CR>==
nnoremap <S-K> :m .-2<CR>==
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Indenting won't throw you out of visual mode
vnoremap <lt> <lt>gv
vnoremap > >gv

" Fix vim Y behavior
nnoremap Y y$

" Fix ctrl backspace behavior
noremap! <C-BS> <C-w>
noremap! <C-h> <C-w>

" Remove the most toxic vim mode to exist and remap it to repeat the last macro.
nnoremap Q @@

" Merge lines
nnoremap <S-M> <S-J>

" Indenting won't throw you out of visual mode
vnoremap <LT> <LT>gv
vnoremap > >gv

" Yank to system clipboard
nnoremap <leader>y "+y
vnoremap <leader>y "+y
