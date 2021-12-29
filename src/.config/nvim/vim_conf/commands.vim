function! Format_sync()
    lua vim.lsp.buf.formatting_sync(nil, 1000)
endfunction

" Format the current buffer if an lsp formatter is defined.
command Format call Format_sync()
command W w
