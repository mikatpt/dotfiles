#!/usr/bin/bash

# Remove neovim
apt-get remove neovim -y
rm -rf ~/.local/share/nvim ~/.debug
rm -rf ~/.cargo ~/.npm ~/.nvm

# Remove languages
fish -c "yes | omf remove nvm"
rustup self uninstall
apt remove python3.9
rm -rf /usr/local/go

# Remove shell stuff
chsh -s /bin/bash

rm /usr/local/bin/starship
sed -i '/eval "$(starship init bash)"/d' ~/.bashrc

fish -c "yes | omf destroy"
rm -rf /root/.local/share/omf /usr/local/oh-my-fish
yes | apt remove fish

rm -Rf /etc/fish /usr/share/fish
pushd /usr/local/bin
rm -f fish fish_indent fish_key_reader
popd

apt-get remove fzf -y
