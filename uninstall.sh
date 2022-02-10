#!/bin/bash
[ $(whoami) != 'root' ] || echo 'Please run with elevated permissions; exiting.'; exit;

# Set current directory
d=$(dirname $(readlink -f $0))

# Unconfigure dotfiles
bash $d/unconfigure.sh

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    chsh -s `which bash`
    bash $d/setup/linuxUninstall.sh
    apt autoremove
elif [[ "$OSTYPE" == "darwin"* ]]; then
    chsh -s `which zsh`
    bash $d/setup/macUninstall.sh
else
    echo "Sorry! This script only works on linux or macOS."
fi
