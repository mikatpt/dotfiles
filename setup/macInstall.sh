#!/usr/bin/bash

source $d/shared.sh

brew update
brew install fish starship fzf golang pyenv nvm rustup-init
pyenv install 3.9.2

brew install --HEAD luajit
brew install --HEAD neovim
nvim --headless +"Lazy restore" +qall
nvim --headless +"LspInstall efm gopls bashls html jsonls sumneko_lua rust_analyzer tsserver yamlls vimls" +qall

_install_omf
_install_languages
_install_neovim
_install_debuggers
