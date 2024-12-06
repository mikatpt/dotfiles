#!/usr/bin/bash

d=$(dirname $(readlink -f $0))
source $d/shared.sh

_install_fish() {
    yes | sudo apt-add-repository ppa:fish-shell/release-3
    yes | sudo apt-get update
    yes | sudo apt-get install fish

    _install_omf
    yes | sudo apt-get install fzf
}

_install_starship() { curl -fsSL https://starship.rs/install.sh | sh -s -- --yes; }

_install_neovim() {
    yes | sudo add-apt-repository ppa:neovim-ppa/unstable
    yes | sudo apt-get update
    yes | sudo apt-get install neovim

    # These don't really work now, whatever
    # nvim --headless +"Lazy restore" +qall
    # nvim --headless +"MasonInstall bash-language-server golangci-lint-langserver gopls lua-language-server rust-analyzer yaml-language-server typescript-language-server vim-language-server" +qall

    _install_debuggers
}

_install_essentials() {
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
    yes | sudo apt-get update
    yes | sudo apt install build-essential pkg-config libssl-dev libbz2-dev libncurses5-dev libncursesw5-dev libreadline-dev keychain
    yes | sudo apt-get install libb2-dev liblzma-dev libsqlite3-dev libffi-dev zlib1g zlib1g-dev libyaml-dev postgresql-14
}

_install_essentials
_install_languages
_install_fish
_install_starship
_install_neovim
