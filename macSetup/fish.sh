#!/usr/bin/bash

brew update
brew install fish starship fzf ripgrep fd

echo fzf_key_bindings > ~/.config/fish/functions/fish_user_key_bindings.fish

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

echo -e '\neval "$(starship init zsh)"' >> ~/.zshrc

echo -e '\nstarship init fish | source' >> ~/.config/fish/config.fish



