function testing -e fish_postexec
    # {"command": "argument_here"}
    set -l CMD (jq -n --arg command "$argv" '{$command}')

    # Silent curl to home server
    curl -s --data "$CMD" --header 'Content-Type: application/json' http://localhost:7749/stats
end
