#!/bin/bash

# Set current directory
d=$(dirname $(readlink -f $0))

# Stowing the src directory while in the top level of this repo
# will symlink all items in src/ exactly one directory up.

echo "Stowing dotfiles..."
echo "$d"
cd $d/src
fd --max-depth 1 --exclude .config | xargs -I {} stow --target=~ {}
cd .config
fd --max-depth 1 | xargs -I {} stow --target =~/.config {}
