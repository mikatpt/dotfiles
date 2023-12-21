#!/usr/bin/bash

# Remove neovim
brew uninstall --HEAD luajit
brew uninstall --HEAD neovim
rm -rf ~/.local/share/nvim ~/.debug

# Remove languages
brew uninstall rustup-init nvm pyenv golang fzf
rm -rf ~/.cargo ~/.npm ~/.nvm
rustup self uninstall
rm -rf /usr/local/go
rm -rf ~/.local/share/rtx

# Remove shell stuff
chsh -s /bin/bash

rm /usr/local/bin/starship
sed -i '/eval "$(starship init bash)"/d' ~/.bashrc

rm -rf /root/.local/share/omf /usr/local/oh-my-fish
fish -c "yes | omf destroy"
rm -Rf /etc/fish /usr/share/fish

pushd /usr/local/bin
rm -f fish fish_indent fish_key_reader
popd

brew uninstall fish starship
