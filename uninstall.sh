#!/bin/bash


if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo chsh -s `which bash`
    bash cleanup/nvim.sh
    bash cleanup/dev.sh
    bash cleanup/fish.sh
    sudo apt autoremove
elif [[ "$OSTYPE" == "darwin"* ]]; then
    sudo chsh -s `which zsh`
    bash macCleanup/nvim.sh
    bash macCleanup/dev.sh
    bash macCleanup/fish.sh
else
    echo "Sorry! This script only works on linux or macOS."
fi
