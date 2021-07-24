let g:home = "~"

if exists(':vscode')
    " VSCode extension
    xmap gc <Plug>VSCodeCommentary
    nmap gc <Plug>VSCodeCommentary
    omap gc <Plug>VSCodeCommentary
    nmap gcc <Plug>VSCodeCommentary
    set clipboard=unnamedplus
    :nnoremap <Space> :noh<CR>
else
    " ordinary neovim
	set runtimepath^=~/.vim runtimepath+=~/.vim/after
	let &packpath = &runtimepath
    execute "source " . fnamemodify(home, ":p:H") . "config/nvim/config.vim"
endif
