function testing -e fish_postexec
    # {"command": "argument_here"}
    set -l CMD (jq -n --arg command "$argv" '{$command}')

    # Silent curl to home server
    curl --data "$CMD" --header 'Content-Type: application/json' http://localhost:7749/stats 1>/dev/null 2>/dev/null
end
