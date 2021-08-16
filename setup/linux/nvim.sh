#!/usr/bin/bash

# Install neovim
yes | sudo add-apt-repository ppa:neovim-ppa/unstable
yes | sudo apt-get update
yes | sudo apt-get install neovim

# Setup neovim
nvim --headless +PackerInstall +qall
nvim --headless +"LspInstall bash" +"LspInstall lua" +"LspInstall vim" +qall

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
cd ~/.debug/vscode-node-debug2
npm i
npm run build
