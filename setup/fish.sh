#!/usr/bin/bash

# Install fish
yes | sudo apt-add-repository ppa:fish-shell/release-3
yes | sudo apt-get update
yes | sudo apt-get install fish

# Install starship

curl -fsSL https://starship.rs/install.sh | bash -s -- --yes

# Install fzf
yes | apt-get install fzf
echo fzf_key_bindings > ~/.config/fish/functions/fish_user_key_bindings.fish

# Install ripgrep
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep_12.1.1_amd64.deb
sudo dpkg -i ripgrep_12.1.1_amd64.deb
rm ripgrep_12.1.1_amd64.deb

# Install fdfind
sudo apt install fd-find
sudo ln -s /usr/bin/fdfind /usr/bin/fd


# Install OMF and bass
cd /usr/local
sudo git clone https://github.com/oh-my-fish/oh-my-fish
cd oh-my-fish
bin/install --offline --noninteractive

yes | fish -c "omf install bass"

mkdir -p ~/.config/fish/conf.d
cp ~/config/fish/config.fish ~/.config/fish

echo -e '\neval "$(starship init bash)"' >> ~/.bashrc

echo -e '\nstarship init fish | source' >> ~/.config/fish/config.fish

