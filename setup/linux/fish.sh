#!/usr/bin/bash

install_fish() {
    yes | sudo apt-add-repository ppa:fish-shell/release-3
    yes | sudo apt-get update
    yes | sudo apt-get install fish
}

install_starship() { curl -fsSL https://starship.rs/install.sh | bash -s -- --yes; }

# Installs fzf, ripgrep, fdfind, and oh-my-fish
install_dependencies() {
    yes | apt-get install fzf
    echo fzf_key_bindings > ~/.config/fish/functions/fish_user_key_bindings.fish

    curl -LO https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep_12.1.1_amd64.deb
    sudo dpkg -i ripgrep_12.1.1_amd64.deb
    rm ripgrep_12.1.1_amd64.deb

    sudo apt install fd-find
    sudo ln -s /usr/bin/fdfind /usr/bin/fd

    cd /usr/local
    sudo git clone https://github.com/oh-my-fish/oh-my-fish
    cd oh-my-fish
    bin/install --offline --noninteractive

    yes | fish -c "omf install bass"
}

install_fish
install_starship
install_dependencies
