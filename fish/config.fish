# Source all alias functions
source ~/config/fish/myFunctions.fish

# Source local bashrc
bass source ~/.bashrc

# Fix Ctrl-Backspace behavior
bind \cH 'backward-kill-word'
