function _check_postgres
    docker ps | rg postgres -q
    if test $status -eq 1
        echo "Postgres is not online! Please start postgres and manually restart home server"
        exit
    end
end

function _apply_stats_hook
    echo "Applying stats hook"
    source ~/.config/fish/personal/stats_hook.fish
end

_check_postgres
