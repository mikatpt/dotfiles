#!/bin/bash

# Set current directory
d=$(dirname $(readlink -f $0))

# Unconfigure dotfiles
bash $d/unconfigure.sh

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo chsh -s `which bash`
    bash $d/cleanup/linux/nvim.sh
    bash $d/cleanup/linux/dev.sh
    bash $d/cleanup/linux/fish.sh
    sudo apt autoremove
elif [[ "$OSTYPE" == "darwin"* ]]; then
    sudo chsh -s `which zsh`
    bash $d/cleanup/mac/nvim.sh
    bash $d/cleanup/mac/dev.sh
    bash $d/cleanup/mac/fish.sh
else
    echo "Sorry! This script only works on linux or macOS."
fi
