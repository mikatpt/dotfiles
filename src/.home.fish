function _check_postgres
    docker ps | rg postgres -q
    if test $status -eq 1
        echo "Postgres is not online! Please start postgres and restart terminal with 'exec fish'"
        exit
    end
end

function _start_home_server
    echo "Initializing home server"
    set paneID (wezterm.exe cli list --format json | jq '.[] | select(.workspace == "home") | .pane_id')
    echo 'keychain --eval $SSH_KEYS_TO_AUTOLOAD | source' | wezterm.exe cli send-text --pane-id $paneID --no-paste
    echo 'cargo run --release' | wezterm.exe cli send-text --pane-id $paneID --no-paste
end

function _apply_stats_hook
    echo "Applying stats hook"
    source ~/.config/fish/personal/stats_hook.fish
end

_check_postgres
_start_home_server
