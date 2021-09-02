" Keybindings
" In any given buffer, run :map to see a list of all active keybindings.

""" Useful default keybindings:
" q/ opens up editable buffer for search
" q: opens up editable buffer for vim command line

""" VIM DEFAULT OVERRIDES
let mapleader = " "
inoremap jk <esc>
tnoremap <Esc> <C-\><C-N>
tnoremap jk <C-\><C-N>

" Fix vim Y behavior
nnoremap Y y$

" Remove the most toxic vim mode to exist and remap it to repeat the last macro.
nnoremap Q @@

" Merge lines
nnoremap <S-M> <S-J>

" Use J and K to move lines up and down.
nnoremap <S-K> :m .-2<CR>==
nnoremap <S-J> :m .+1<CR>==
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" additionally, m is rebound to lsp hover actions. I don't use marks \(-_-)/

""" END VIM DEFAULT OVERRIDES

" Indenting won't throw you out of visual mode
vnoremap <LT> <LT>gv
vnoremap > >gv

" Fix ctrl backspace behavior
noremap! <C-BS> <C-W>
noremap! <C-H> <C-W>

" Insert
inoremap <C-J> <Esc>o
inoremap <S-CR> <Esc>O

" From vim-commentary:
" gc to comment out lines

" Resize splits
nnoremap <silent> <S-LEFT> :vert res -5<CR>
nnoremap <silent> <S-RIGHT> :vert res +5<CR>
nnoremap <silent> <S-UP> :res +5<CR>
nnoremap <silent> <S-DOWN> :res -5<CR>

" Use space j or k to open new splits, and Ctrl hjkl to move between them.
nnoremap <leader>j :topleft vsp<CR>
nnoremap <leader>k :vsp<CR>
nnoremap <leader><S-J> :topleft vsp<CR>
nnoremap <leader><S-K> :vsp<CR>
nnoremap <C-J> <C-W><S-W>
nnoremap <C-K> <C-W>w
nnoremap <C-H> <C-W>h
nnoremap <C-L> <C-W>l

tnoremap <C-J> <C-\><C-N><C-W><S-W>
tnoremap <C-K> <C-\><C-N><C-W>w
tnoremap <C-H> <C-\><C-N><C-W>h
tnoremap <C-L> <C-\><C-N><C-W>l

" File Tree
nnoremap <silent><C-N> :NvimTreeToggle<CR>
tnoremap <silent><C-N> <C-\><C-N> :NvimTreeToggle<CR>
nnoremap <silent><leader>nf :NvimTreeFindFile<CR>
nnoremap <leader>nr :NvimTreeRefresh<CR>

" set current working directory to current file
nnoremap <leader>cd :cd %:p:h<CR>

" Toggle relative/absolute line numbers
nnoremap <leader>l :set rnu!<CR>

" Open in Github
nnoremap <silent> <leader>go <CMD>GBrowse<CR>

" Open a terminal in vim.
nnoremap <silent> <leader>t :lua require('harpoon.term').gotoTerminal({ idx = 1, create_with = ':e term://' .. vim.fn.system('echo $SHELL') })<CR>

" Mark files and access them from 1-9.
nnoremap <leader>m :lua require("harpoon.mark").add_file()<CR>
nnoremap <leader><S-M> :lua require("harpoon.ui").toggle_quick_menu()<CR>
for i in [1, 2, 3, 4, 5, 6, 7, 8, 9]
    execute 'nnoremap <silent> <leader>' .. i .. ' :lua require("harpoon.ui").nav_file(' .. i .. ')<CR>'
endfor

" Find files (Telescope)
nnoremap <C-P> <CMD>Telescope git_files<CR>
nnoremap <leader>p <CMD>Telescope find_files<CR>
nnoremap <leader>o <CMD>Telescope oldfiles<CR>
nnoremap <leader>z :lua require"telescope.builtin".git_files({cwd = "$HOME/.config/nvim" })<CR>
nnoremap <leader>b <CMD>Telescope buffers<CR>

" Ripgrep for input or current word
nnoremap <leader>f :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>
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
nnoremap <silent> <leader>d :lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>
