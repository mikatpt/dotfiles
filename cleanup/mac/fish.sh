#!/usr/bin/bash

brew uninstall starship fish fzf ripgrep fd

sudo rm /usr/local/bin/starship
sed -i '/eval "$(starship init bash)"/d' ~/.bashrc
sed -i '/eval "$(starship init bash)"/d' ~/.zshrc
sed -i '/starship init fish | source/d' ~/.config/fish/config.fish

sudo rm -rf /root/.local/share/omf /usr/local/oh-my-fish
