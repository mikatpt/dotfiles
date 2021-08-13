#!/bin/bash

# Set current directory
d=$(dirname $(readlink -f $0))

echo "Unstowing dotfiles..."
cd $d
stow -D src
