#!/bin/bash
# [ $(whoami) != 'root' ] || echo 'Please run with elevated permissions; exiting.'; exit;

install_stow() {
    echo "Checking packages..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ $(dpkg-query -W -f='${Status}' apt 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
            echo "Error - please install apt and run this script again."
            exit
        fi
        apt install build-essential gcc
        apt-get install -y stow
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        which -s brew
        if [[ $? != 0 ]] ; then
            echo "Error - please install brew and run this script again."
            exit
        fi
        brew install stow
    else
        echo "Error - this script only works on linux or macos."
        exit
    fi
}

# Configure dotfiles
stow_files() {
    bash $1/configure.sh
}

install_packages() {
    echo "Installing packages..."
    # Order is important here! Setup fish before dev.
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        bash $d/setup/linuxInstall.sh
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        bash $d/setup/macInstall.sh
    else
        echo "sorry! this script only works on linux or macos."
    fi

}

echo "Setting up environment... 🚀"

# Set current directory
d=$(dirname $(readlink -f $0))

install_stow
install_packages
stow_files $d

echo "Done. 👍"
