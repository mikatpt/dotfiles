if status is-interactive
    # Source local bashrc
    bass source ~/.bashrc

    # Fix Ctrl-Backspace behavior
    bind \cH 'backward-kill-word'

    starship init fish | source
end

set GOPATH "$HOME/go/bin"
fish_add_path /usr/local/go/bin
fish_add_path $HOME/.local/share/solana/install/active_release/bin
bass source $HOME/.cargo/env
