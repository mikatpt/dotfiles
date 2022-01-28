" don't allow mouse events when window is inactive.
autocmd FocusLost * set mouse=
autocmd FocusGained * lua require'core.utils'.fn.defer_mouse()

" allow config files to have comments in them.
augroup assign_jsonc
    autocmd!
    autocmd BufNewFile,BufRead tsconfig.json setlocal filetype=jsonc
    autocmd BufNewFile,BufRead package.json setlocal filetype=jsonc
augroup end

" Extend the Todo syntax group
function! UpdateTodoKeywords(...)
    " Execute only once per buffer, and only for files which have a filetype.
    if exists('b:ExecutedTodoUpdate') || empty(expand("%:e"))
        return
    endif

    " For some reason 'syntax on' doesn't immediately fire - probably due to
    " TreeSitter funkiness. Update later if there's a better workaround.
    syntax on
    let b:ExecutedTodoUpdate = 1

    let newKeywords = join(a:000, " ")
    let synTodo = map(filter(split(execute("syntax list"), '\n') , { i,v -> match(v, '^\w*Todo\>') == 0}), {i,v -> substitute(v, ' .*$', '', '')})
    for synGrp in synTodo
        execute "syntax keyword " . synGrp . " contained " . newKeywords
    endfor
endfunction

augroup updateTodos
    autocmd!
    autocmd BufEnter * call UpdateTodoKeywords("NOTE", "FIX", "FIXIT", "ISSUE", "FAIL", "WARN", "PERF", "OPTIM", "SAFETY")
augroup END
