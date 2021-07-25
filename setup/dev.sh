#!/usr/bin/bash

# Install nvm
yes | curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
fish -c "yes | omf install nvm"
fish -c "nvm install node"

npm install -g neovim

# Install go
curl -L https://golang.org/dl/go1.16.6.linux-amd64.tar.gz --output ~/go1.16.6.tar.gz

tar -C /usr/local -xzf ~/go1.16.6.tar.gz
sudo rm ~/go1.16.6.tar.gz

# Install python
yes | sudo apt update
yes | sudo apt install software-properties-common
yes | add-apt-repository ppa:deadsnakes/ppa
yes | apt install python3.9


