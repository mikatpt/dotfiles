" don't allow mouse events when window is inactive.
autocmd FocusLost * set mouse=
autocmd FocusGained * lua require'core.utils'.fn.defer_mouse()

" allow config files to have comments in them.
augroup assign_jsonc
    autocmd!
    autocmd BufNewFile,BufRead tsconfig.json setlocal filetype=jsonc
    autocmd BufNewFile,BufRead package.json setlocal filetype=jsonc
augroup end
