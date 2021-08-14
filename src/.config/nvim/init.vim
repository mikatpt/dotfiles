set runtimepath^=~/.config/nvim/config
set runtimepath+=~/.config/nvim/after
set packpath^=~/.local/share/nvim/site
let g:home = "~"

" Source all config files
lua require('config')
runtime! config/**/*.vim