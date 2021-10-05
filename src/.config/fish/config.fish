if status is-interactive
    # Check if in tmux, then create session 'main' with two windows if it doesn't exist
    if not set -q TERM_PROGRAM && not set -q TMUX
        tmux has-session -t main 2>/dev/null || tmux new-session -d -s main
        tmux if-shell 'tmux select-window -t 2' 'select-window -t 1' 'new-window -d -t main'
        tmux attach -t main
    end

    # Source local bashrc
    bass source ~/.bashrc

    # Fix Ctrl-Backspace behavior
    bind \cH 'backward-kill-word'

    starship init fish | source
end

set GOPATH "$HOME/go/bin"
fish_add_path /usr/local/go/bin
fish_add_path $HOME/.local/share/solana/install/active_release/bin
fish_add_path $HOME/.local/share/nvim/lspinstall/rust
bass source $HOME/.cargo/env
