#!/bin/bash

# Order is important here! Setup fish before dev.

bash fishSetup.sh
bash devSetup.sh
bash nvimSetup.sh

sudo chsh -s `which fish`
fish
