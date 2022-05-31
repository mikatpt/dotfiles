if status is-interactive
    # Check if in tmux and if in a terminal, then create a new tmux session 'main' with
    # four windows if it doesn't already exist
    if not set -q TERM_PROGRAM && not set -q TMUX
        tmux has-session -t main 2>/dev/null
        if test ! $status -eq 0
            tmux new-session -d -s main
            tmux new-window -d -t main
            tmux new-window -d -t main
            tmux new-window -d -t main
            tmux select-window -t main:1
            tmux rename-window -t main:4 config
        end
        tmux list-sessions | rg --quiet main 2>/dev/null && tmux attach -t main
    end

    # Tmux copying requires special care in WSL
    if set -q TMUX
        grep -q 'WSL\|Microsoft' /proc/version
        if test $status -eq 0
            tmux bind-key -T copy-mode-vi 'y' send -X copy-pipe-and-cancel 'clip.exe'
        end
    end

    # Start our home server
    source ~/.home.fish
    _apply_stats_hook

    # Source local bashrc
    bass source ~/.bashrc

    # Fix Ctrl-Backspace behavior
    bind \cH 'backward-kill-word'

    # unbind ctrl d exit
    bind \cd true

    starship init fish | source
end

set GOPATH "$HOME/go/bin"

fish_add_path /usr/local/go/bin
fish_add_path $GOPATH
fish_add_path $HOME/.local/share/nvim/lsp_servers/rust
bass source $HOME/.cargo/env
