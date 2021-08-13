#!/bin/bash

# Set current directory
d=$(dirname $(readlink -f $0))

# Stowing the src directory while in the top level of this repo
# will symlink all items in src/ exactly one directory up.

echo "Stowing dotfiles..."
cd $d
stow src
