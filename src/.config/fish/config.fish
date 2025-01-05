set GOPATH "$HOME/go"

# from jonhoo - one dir for all rust builds
setenv CARGO_TARGET_DIR ~/.cargo-target
setenv DENO_INSTALL $HOME/.deno/bin/deno
fish_add_path $HOME/.local/bin
fish_add_path $GOPATH
fish_add_path $GOPATH/bin
fish_add_path $HOME/.local/share/nvim/lsp_servers/rust
fish_add_path $HOME/.deno/bin
bass source $HOME/.cargo/env

if type -q mise 
    mise activate fish | source
end

# Make sure cargo bin is in path first for fd
set -x SSH_KEYS_TO_AUTOLOAD (fd -t f 'id_*' ~/.ssh -E '*.pub')

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/mikatpt/google-cloud-sdk/path.fish.inc' ]; . '/home/mikatpt/google-cloud-sdk/path.fish.inc'; end

if status is-interactive
    echo "Applying stats hook"
    source ~/.config/fish/personal/stats_hook.fish

    # Source local bashrc
    bass source ~/.bashrc

    # Fix Ctrl-Backspace behavior
    bind \cH 'backward-kill-word'

    # unbind ctrl d exit
    bind \cd true

    zoxide init fish | source
    starship init fish | source
    fzf_key_bindings
end
