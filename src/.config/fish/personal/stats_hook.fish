function testing -e fish_postexec
    set -l CMD (jq -n --arg command "$argv" '{$command}')
    curl --data "$CMD" --header 'Content-Type: application/json' http://localhost:7749/stats
end
