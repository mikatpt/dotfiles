function testing -e fish_postexec
    # {"command": "argument_here"}
    set -l CMD (jq -n --arg command "$argv" '{$command}')

    # Silent curl to home server for tracking
    curl -H 'Content-Type: application/json' --data-raw "$CMD" localhost:7749/stats 1>/dev/null 2>/dev/null
end
