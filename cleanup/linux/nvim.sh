#!/usr/bin/bash

sudo apt-get remove neovim -y

sudo rm -rf ~/.config/nvim/.vim/plugged
sudo rm -rf ~/.config/nvim/.vim/autoload
