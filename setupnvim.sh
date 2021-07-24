#!/usr/bin/bash

# Install neovim
yes | sudo add-apt-repository ppa:neovim-ppa/unstable
yes | sudo apt-get update
yes | sudo apt-get install neovim

# Setup neovim
mkdir -p ~/.config/nvim
mkdir -p ~/.vim/colors
mkdir -p ~/.vim/after/plugin

cp ~/config/nvim/init.vim ~/.config/nvim/init.vim
cp ~/config/nvim/lucid.vim ~/.vim/colors

nvim -c 'source % | quit'

cp ~/config/nvim/telescope.nvim.vim ~/.vim/after/plugin/telescope.nvim.vim

nvim -c 'source % | quit'

