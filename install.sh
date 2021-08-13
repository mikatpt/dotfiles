#!/bin/bash

echo "Checking packages..."
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [ $(dpkg-query -W -f='${Status}' apt 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
        echo "Error - please install apt and run this script again."
        exit
    fi
    sudo apt-get install -y stow
elif [[ "$OSTYPE" == "darwin"* ]]; then
    which -s brew
    if [[ $? != 0 ]] ; then
        echo "Error - please install brew and run this script again."
        exit
    fi
    brew install stow
else
    echo "sorry! this script only works on linux or macos."
    exit
fi

# Set current directory
d=$(dirname $(readlink -f $0))

# Configure dotfiles
bash $d/configure.sh

echo "Installing packages..."
# Order is important here! Setup fish before dev.
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    bash $d/setup/linux/fish.sh
    bash $d/setup/linux/dev.sh
    bash $d/setup/linux/nvim.sh
elif [[ "$OSTYPE" == "darwin"* ]]; then
    bash $d/setup/mac/fish.sh
    bash $d/setup/mac/dev.sh
    bash $d/setup/mac/nvim.sh
else
    echo "sorry! this script only works on linux or macos."
fi
