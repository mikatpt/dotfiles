function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" Tab autocompletion
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()

" Enter auto-selects first completion item.
"inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() :
"  \ "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

if has("patch-8.1.1564")
  set signcolumn=number
else
  set signcolumn=no
endif

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')
