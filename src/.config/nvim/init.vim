set runtimepath^=~/.config/nvim/.vim,~/.config/nvim/config runtimepath+=~/.config/nvim/.vim/after
let &packpath = &runtimepath

" Source all config files
runtime plugins.vim
lua require('core')
runtime! config/**/*.vim
