" Keybindings
" In any given buffer, run :map to see a list of all active keybindings.

""" Useful default keybindings:
" q/ opens up editable buffer for search
" q: opens up editable buffer for vim command line

let mapleader = " "
inoremap jk <esc>
nmap <silent>; :

" Fix ctrl backspace behavior
noremap! <C-BS> <C-W>
noremap! <C-H> <C-W>

" Fix vim Y behavior
nnoremap Y y$

" Remove the most toxic vim mode to exist and remap it to repeat the last macro.
nnoremap Q @@

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

" File Tree
nnoremap <C-N> :NvimTreeToggle<CR>
" Open current file in tree
nnoremap <leader>nf :NvimTreeFindFile<CR>
nnoremap <leader>nr :NvimTreeRefresh<CR>

" set current working directory to current file
nnoremap <leader>cd :cd %:p:h<CR>

" Toggle relative/absolute line numbers
nnoremap <leader>l :set rnu!<CR>

" Open in Github
nnoremap <silent> <leader>go <CMD>GBrowse<CR>

" Use lspsaga's handy ui for code actions and reference previewing.
nnoremap <silent> gp <CMD>lua require'lspsaga.provider'.preview_definition()<CR>
nnoremap <silent> gr <CMD>lua require'lspsaga.provider'.lsp_finder()<CR>
nnoremap <silent><leader>ca <CMD>lua require('lspsaga.codeaction').code_action()<CR>
vnoremap <silent><leader>ca :<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>
" scroll down hover doc or scroll in definition preview
nnoremap <silent> <C-f> <CMD>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
" scroll up hover doc
nnoremap <silent> <C-e> <CMD>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>

" Use J and K to move lines up and down.
nnoremap <S-J> :m .+1<CR>==
nnoremap <S-K> :m .-2<CR>==
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Indenting won't throw you out of visual mode
vnoremap <LT> <LT>gv
vnoremap > >gv

" From vim-commentary:
" gc to comment out lines

" Find files (Telescope)
nnoremap <C-P> <CMD>Telescope git_files<CR>
nnoremap <leader>p <CMD>Telescope find_files<CR>
nnoremap <leader>o <CMD>Telescope oldfiles<CR>
nnoremap <leader>z :lua require"telescope.builtin".git_files({cwd = "$HOME/.config/nvim" })<CR>
nnoremap <leader>b <CMD>Telescope buffers<CR>
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
