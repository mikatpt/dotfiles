if status is-interactive
    # Check if in tmux, then create session 'main' with two windows if it doesn't exist
    if not set -q TERM_PROGRAM && not set -q TMUX
        tmux has-session -t main 2>/dev/null || tmux new-session -d -s main
        tmux if-shell 'tmux select-window -t main:2' '' 'new-window -d -t main'
        tmux if-shell 'tmux select-window -t main:3' '' 'new-window -d -t main'
        tmux if-shell 'tmux select-window -t main:4' '' 'new-window -d -t main'
        tmux rename-window -t main:4 config
        tmux list-sessions | rg --quiet main 2>/dev/null && tmux attach -t main
    end

    # Start our home server
    fish ~/.home.fish

    # Source local bashrc
    bass source ~/.bashrc

    # Fix Ctrl-Backspace behavior
    bind \cH 'backward-kill-word'

    starship init fish | source
end

set GOPATH "$HOME/go/bin"

fish_add_path /usr/local/go/bin
fish_add_path $HOME/.local/share/nvim/lsp_servers/rust
bass source $HOME/.cargo/env
