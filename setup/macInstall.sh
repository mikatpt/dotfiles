#!/usr/bin/bash

brew update
brew install fish starship fzf golang pyenv nvm rustup-init
pyenv install 3.9.2

_install_fish() {
    pushd /usr/local
    git clone https://github.com/oh-my-fish/oh-my-fish
    cd oh-my-fish
    bin/install --offline --noninteractive

    yes | fish -c "omf install bass"
    popd
}

_install_languages() {
    rustup-init --default-toolchain nightly -y
    cargo install ripgrep fd-find tealdeer eza stylua zoxide bat rtx
    rtx install
    rtx activate | source
    npm install -g neovim eslint_d
    pip install ptpython
}

_install_neovim() {
    brew install --HEAD luajit
    brew install --HEAD neovim

    # Initial setup
    nvim --headless +"Lazy restore" +qall
    nvim --headless +"LspInstall efm gopls bashls html jsonls sumneko_lua rust_analyzer tsserver
    yamlls vimls" +qall

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

_install_fish
_install_languages
_install_neovim
