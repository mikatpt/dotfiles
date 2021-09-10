" AUTOKEYBINDS - can ignore this section!

function! s:ftplugin_fugitive() abort
    nnoremap <buffer> <silent> cc :Git commit --quiet<CR>
    nnoremap <buffer> <silent> ca :Git commit --quiet --amend<CR>
    nnoremap <buffer> <silent> ce :Git commit --quiet --amend --no-edit<CR>
endfunction
augroup nhooyr_fugitive
    autocmd!
    autocmd FileType fugitive call s:ftplugin_fugitive()
augroup END

autocmd FileType harpoon nnoremap <buffer> <silent> q :q<CR>
autocmd FileType harpoon nnoremap <buffer> <silent> <ESC> :q<CR>

autocmd FileType lspinfo nnoremap <buffer> <silent> q :q<CR>
autocmd FileType lspinfo nnoremap <buffer> <silent> <ESC> :q<CR>
