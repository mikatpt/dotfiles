#!/usr/bin/bash

# Install neovim
yes | sudo add-apt-repository ppa:neovim-ppa/unstable
yes | sudo apt-get update
yes | sudo apt-get install neovim

# Setup neovim
mkdir -p ~/.config/nvim
mkdir -p ~/.vim/colors
mkdir -p ~/.vim/after/plugin

# Install Plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

cp ~/config/nvim/init.vim ~/.config/nvim/init.vim
cp ~/config/nvim/lucid.vim ~/.vim/colors/lucid.vim
cp ~/config/nvim/telescope.nvim.vim ~/.vim/after/plugin/telescope.nvim.vim

nvim +PlugInstall +qall

# Go debugging
mkdir -p ~/.debug
cd ~/.debug
git clone https://github.com/golang/vscode-go 
cd ~/.debug/vscode-go
npm i
npm run compile

# JavaScript debugging
cd ~/.debug
git clone https://github.com/microsoft/vscode-node-debug2.git
npm i
npm run build

