#!/usr/bin/bash

_install_omf() {
    pushd /usr/local
    git clone https://github.com/oh-my-fish/oh-my-fish
    cd oh-my-fish
    bin/install --offline --noninteractive

    fish -c "yes | omf install bass"
    popd
}

_install_languages() {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    # make sure we have cargo in path before continuing.
    . "$HOME/.cargo/env"
    cargo install ripgrep fd-find tealdeer eza stylua zoxide bat mise bacon just genact

    # install all languages
    mise install
    source <(rtx activate bash)
    npm install -g neovim eslint_d gulp prettier
    pip install ptpython
}

_install_debuggers() {
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
