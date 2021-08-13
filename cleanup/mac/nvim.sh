#!/usr/bin/bash

brew uninstall --HEAD luajit
brew uninstall --HEAD neovim

sudo rm -rf ~/.config/nvim/.vim/plugged
sudo rm -rf ~/.config/nvim/.vim/autoload
