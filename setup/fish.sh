#!/usr/bin/bash

# Install fish
yes | sudo apt-add-repository ppa:fish-shell/release-3
yes | sudo apt-get update
yes | sudo apt-get install fish

# Install starship

curl -fsSL https://starship.rs/install.sh | bash -s -- --yes

# Install OMF and bass
cd /usr/local
sudo git clone https://github.com/oh-my-fish/oh-my-fish
cd oh-my-fish
bin/install --offline --noninteractive

yes | fish -c "omf install bass"

mkdir -p ~/.config/fish/conf.d
cp ~/config/fish/config.fish ~/.config/fish
cp ~/config/fish/myFunctions.fish ~/.config/fish/conf.d/myFunctions.fish

echo -e '\neval "$(starship init bash)"' >> ~/.bashrc

echo -e '\nstarship init fish | source' >> ~/.config/fish/config.fish

