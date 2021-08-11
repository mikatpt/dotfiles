#!/usr/bin/bash

brew uninstall --HEAD luajit
brew uninstall --HEAD neovim

sudo rm -rf ~/.config/nvim
sudo rm -rf ~/.vim
