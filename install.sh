#!/bin/bash

# Order is important here! Setup fish before dev.

bash setup/fish.sh
bash setup/dev.sh
bash setup/nvim.sh

sudo chsh -s `which fish`
