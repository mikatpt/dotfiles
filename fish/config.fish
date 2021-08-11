# Source all alias functions
source ~/config/fish/myFunctions.fish

source ~/config/fish/plugins.fish

# Source local bashrc
bass source ~/.bashrc

# Fix Ctrl-Backspace behavior
bind \cH 'backward-kill-word'
