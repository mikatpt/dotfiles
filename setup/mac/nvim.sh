#!/usr/bin/bash

# Install neovim
brew install --HEAD luajit
brew install --HEAD neovim

# Setup neovim
nvim +PackerInstall +qall

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