#!/usr/bin/bash

_install_fish() {
    yes | apt-add-repository ppa:fish-shell/release-3
    yes | apt-get update
    yes | apt-get install fish

    pushd /usr/local
    git clone https://github.com/oh-my-fish/oh-my-fish
    cd oh-my-fish
    bin/install --offline --noninteractive

    fish -c "yes | omf install bass"
    popd

    yes | apt-get install fzf
}

_install_starship() { curl -fsSL https://starship.rs/install.sh | bash -s -- --yes; }

_install_languages() {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    # make sure we have cargo in path before continuing.
    . "$HOME/.cargo/env"
    cargo install ripgrep fd-find tealdeer eza stylua zoxide bat rtx

    # install all languages
    rtx install
    rtx activate | source
    npm install -g neovim eslint_d
    pip install ptpython
}

_install_neovim() {
    yes | add-apt-repository ppa:neovim-ppa/unstable
    yes | apt-get update
    yes | apt-get install neovim


    # Initial setup
    nvim --headless +"Lazy restore" +qall
    nvim --headless +"MasonInstall bash-language-server golangci-lint-langserver gopls lua-language-server rust-analyzer yaml-language-server typescript-language-server vim-language-server" +qall

    # Debuggers
    # Go debugging
    mkdir -p ~/.debug
    cd ~/.debug
    git clone https://github.com/golang/vscode-go
    cd ~/.debug/vscode-go
    npm i
    npm run compile

    # JavaScript debugging
    cd ~/.debug
    git clone https://github.com/microsoft/vscode-node-debug2.git
    cd ~/.debug/vscode-node-debug2
    npm i
    npm run build
}

_install_essentials() {
    yes | apt install build-essential
    # for python
    yes | apt-get install libb2-dev liblzma-dev libsqlite3-dev
}

_install_essentials
_install_languages
_install_fish
_install_starship
_install_node
_install_go
_install_python
_install_neovim
