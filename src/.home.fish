function _check_postgres
    set -l POSTGRES_ONLINE (service postgresql status | string match -r 'online')
    if test -z $POSTGRES_ONLINE
        echo "Postgres is not online! Please start postgres and restart terminal with 'exec fish'"
        exit
    end
end

function _start_home_server
    tmux has-session -t home 2>/dev/null
    if test $status -eq 0
        return 1
    end

    echo "Initializing home server"
    tmux new-session -d -s home
    tmux send-keys -t home.1 "cd /home/mikatpt/coding/home/crates/home" ENTER
    tmux send-keys -t home.1 "cargo run --release" ENTER
end

function _apply_stats_hook
    echo "Applying stats hook"
    source ~/.config/fish/personal/stats_hook.fish
end

_check_postgres
_start_home_server
