let g:home = "~"

if exists('g:vscode')
    " VSCode extension
    xmap gc <Plug>VSCodeCommentary
    nmap gc <Plug>VSCodeCommentary
    omap gc <Plug>VSCodeCommentary
    nmap gcc <Plug>VSCodeCommentary
    set clipboard=unnamedplus

    " Other keybindings.
    :nnoremap <Space> :noh<CR>
    execute "source " . fnamemodify(home, ":p:H") . "config/nvim/vscode.vim"
else
    " ordinary neovim
	set runtimepath^=~/.vim runtimepath+=~/.vim/after
	let &packpath = &runtimepath
    execute "source " . fnamemodify(home, ":p:H") . "config/nvim/config.vim"
endif
