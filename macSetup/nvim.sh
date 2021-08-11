#!/usr/bin/bash

# Install neovim
brew install --HEAD luajit
brew install --HEAD neovim

# Setup neovim
mkdir -p ~/.config/nvim
mkdir -p ~/.vim/colors
mkdir -p ~/.vim/after/plugin

# Install Plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

cp ~/config/nvim/init.vim ~/.config/nvim/init.vim
cp ~/config/nvim/lucid.vim ~/.vim/colors
cp ~/config/nvim/telescope.nvim.vim ~/.vim/after/plugin/telescope.nvim.vim

nvim +PlugInstall +qall


