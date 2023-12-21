set GOPATH "$HOME/go"

# from jonhoo - one dir for all rust builds
setenv CARGO_TARGET_DIR ~/.cargo-target
setenv DENO_INSTALL $HOME/.deno/bin/deno
setenv SSH_KEYS_TO_AUTOLOAD "$HOME/.ssh/github_personal"
fish_add_path $HOME/.local/bin
fish_add_path $GOPATH
fish_add_path $HOME/.local/share/nvim/lsp_servers/rust
fish_add_path $HOME/.deno/bin
bass source $HOME/.cargo/env

if type -q rtx 
    rtx activate | source
end

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/mikatpt/google-cloud-sdk/path.fish.inc' ]; . '/home/mikatpt/google-cloud-sdk/path.fish.inc'; end

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

    zoxide init fish | source
    starship init fish | source
end
