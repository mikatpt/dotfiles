" Keybindings

let mapleader = " "
inoremap jk <esc>
nmap <silent>; :

" Fix ctrl backspace behavior
noremap! <C-BS> <C-w>
noremap! <C-h> <C-w>

" Fix vim Y behavior
nnoremap Y y$

" Insert
inoremap <C-J> <Esc>o
inoremap <S-CR> <Esc>O

" Use space j or k to open new splits, and Ctrl hjkl to move between them.
nnoremap <leader>j :topleft vsp<CR>
nnoremap <leader>k :vsp<CR>
nnoremap <leader><S-J> :topleft vsp<CR>
nnoremap <leader><S-K> :vsp<CR>
nnoremap <C-J> <C-W><S-W>
nnoremap <C-K> <C-W>w
nnoremap <C-H> <C-W>h
nnoremap <C-L> <C-W>l

" Use J and K to move lines up and down.
nnoremap <S-J> :m .+1<CR>==
nnoremap <S-K> :m .-2<CR>==
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Indenting won't throw you out of visual mode
vnoremap <lt> <lt>gv
vnoremap > >gv

" From vim-commentary:
" gc to comment out lines

" Find files (Telescope)
nnoremap <C-p> <cmd>Telescope git_files<CR>
nnoremap <leader>p <cmd>Telescope find_files<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>f :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>
" Grep current word under cursor
nnoremap <leader>w :lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>

" Debugging
function! Debug()
    if &filetype == 'go'
        :lua require'dap'.continue()
        :lua require'dap'.repl.open()
    else
        :lua require'dap'.continue()
    endif
endfunction

nnoremap <silent> <F5> :call Debug()<CR>
nnoremap <silent> <F10> :lua require'dap'.step_over()<CR>
nnoremap <silent> <F11> :lua require'dap'.step_into()<CR>
nnoremap <silent> <F12> :lua require'dap'.step_out()<CR>
nnoremap <silent> <C-B> :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> <leader>h :lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>

" Compe keybindings - these are mostly automatic
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm(luaeval("require 'nvim-autopairs'.autopairs_cr()"))
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
