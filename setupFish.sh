#!/usr/bin/bash

# Install fish
yes | sudo apt-add-repository ppa:fish-shell/release-3
yes | sudo apt-get update
yes | sudo apt-get install fish


# Install fontconfig and Source Code Pro font

yes | sudo apt install fontconfig

[ -d /usr/share/fonts/opentype ] || sudo mkdir /usr/share/fonts/opentype
sudo git clone --depth 1 --branch release https://github.com/adobe-fonts/source-code-pro.git /usr/share/fonts/opentype/scp
sudo fc-cache -f -v

# Install starship

yes | curl -fsSL https://starship.rs/install.sh -y

echo -e '\neval "$(starship init bash)"' >> ~/.bashrc

echo -e '\nstarship init fish | source' >> ~/.config/fish/config.fish

# Install bass
curl -L https://get.oh-my.fish | fish
yes | omf install bass

mkdir -p ~/.config/fish/conf.d
cp ~/config/fish/config.fish ~/.config/fish
cp ~/config/fish/myFunctions.fish ~/.config/conf.d/myFunctions.fish

source ~/.config/fish/config.fish
exit
