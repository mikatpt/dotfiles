set GOPATH "$HOME/go"

# from jonhoo - one dir for all rust builds
setenv CARGO_TARGET_DIR ~/.cargo-target
setenv DENO_INSTALL $HOME/.deno/bin/deno
setenv SSH_KEYS_TO_AUTOLOAD "$HOME/.ssh/github_personal"
fish_add_path $HOME/.local/bin
fish_add_path $GOPATH
fish_add_path $GOPATH/bin
fish_add_path $HOME/.local/share/nvim/lsp_servers/rust
fish_add_path $HOME/.deno/bin
bass source $HOME/.cargo/env

if type -q rtx 
    mise activate fish | source
end

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/mikatpt/google-cloud-sdk/path.fish.inc' ]; . '/home/mikatpt/google-cloud-sdk/path.fish.inc'; end

if status is-interactive
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
