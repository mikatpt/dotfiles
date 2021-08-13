#!/usr/bin/bash

sudo rm /usr/local/bin/starship
sed -i '/eval "$(starship init bash)"/d' ~/.bashrc
sed -i '/starship init fish | source/d' ~/.config/fish/config.fish

sudo rm -rf /root/.local/share/omf /usr/local/oh-my-fish
chsh -s /bin/bash
yes | sudo apt remove fish

rm -Rf /etc/fish /usr/share/fish
cd /usr/local/bin
rm -f fish fish_indent fish_key_reader

apt-get remove fzf
sudo rm /usr/bin/rg
apt remove fd-find
