#!/bin/bash

# Order is important here! Setup fish before dev.

bash setupnvim.sh
bash setupFish.sh
bash setupDev.sh

sudo chsh -s `which fish`
