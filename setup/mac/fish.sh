#!/usr/bin/bash

brew update
brew install fish starship fzf ripgrep fd

# Install OMF and bass
cd /usr/local
sudo git clone https://github.com/oh-my-fish/oh-my-fish
cd oh-my-fish
bin/install --offline --noninteractive

yes | fish -c "omf install bass"
