function! FollowSymlink()
    let current_file = expand('%:p')

    if getftype(current_file) == 'link'
        let actual_file = resolve(current_file)
        silent! execute 'file ' . actual_file
    end
endfunction

function! SetProjectRoot()
    call FollowSymlink()
    " default to the current file's directory
    cd %:p:h

    let git_dir = system("git rev-parse --show-toplevel")
    let is_not_git_dir = matchstr(git_dir, '^fatal:.*')

    if empty(is_not_git_dir)
        cd `=git_dir`
    endif
    lua require'nvim-tree'.change_dir(vim.loop.cwd())
endfunction

" follow symlink and set working directory
autocmd WinEnter * call SetProjectRoot()
autocmd BufEnter * call SetProjectRoot()

" don't allow mouse events when window is inactive.
autocmd FocusLost * set mouse=
autocmd FocusGained * lua require'core.utils'.fn.defer_mouse()

" allow config files to have comments in them.
augroup assign_jsonc
    autocmd!
    autocmd BufNewFile,BufRead tsconfig.json setlocal filetype=jsonc
    autocmd BufNewFile,BufRead package.json setlocal filetype=jsonc
augroup end
