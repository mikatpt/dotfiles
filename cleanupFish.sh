#!/usr/bin/bash

sudo rm /usr/local/bin/starship
sed -i '/eval "$(starship init bash)"/d' ~/.bashrc
sed -i '/starship init fish | source/d' ~/.config/fish/config.fish

fish -c "omf destroy"
bash
chsh -s /bin/bash
sudo apt remove fish

rm -Rf /etc/fish /usr/share/fish ~/.config/fish
cd /usr/local/bin
rm -f fish fish_indent fish_key_reader

