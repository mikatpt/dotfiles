#!/bin/bash

# Order is important here! Setup fish before dev.
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    bash setup/fish.sh
    bash setup/dev.sh
    bash setup/nvim.sh
elif [[ "$OSTYPE" == "darwin"* ]]; then
    bash macSetup/fish.sh
    bash macSetup/dev.sh
    bash macSetup/nvim.sh
else
    echo "Sorry! This script only works on linux or macOS."
fi
