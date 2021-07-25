#!/usr/bin/bash

fish -c "yes | omf remove nvm"
sudo rm -rf /usr/local/go
sudo apt remove python3.9
sudo apt autoremove

