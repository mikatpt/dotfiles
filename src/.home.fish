function check_tmux
    if tmux has-session -t home 2>/dev/null
        exit
    end
end

function check_postgres
    set -l POSTGRES_ONLINE (service postgresql status | string match -r 'online')
    if test -z $POSTGRES_ONLINE
        echo "Postgres is not online! Please start postgres and re-run .home.fish."
        exit
    end
end

function start_server
    echo "Initializing home server"
    tmux new-session -d -s home
    tmux send-keys -t home.1 "cd /home/mikatpt/coding/stats/home-server" ENTER
    tmux send-keys -t home.1 "cargo run --release" ENTER
end

check_tmux
check_postgres
start_server
