function testing -e fish_postexec
    # {"command": "argument_here"}
    set -l CMD (jq -n --arg command "$argv" '{$command}')

    # dirty workaround - using jq to escape quotes for us.
    set -l MUTATION 'mutation { viewer { insertStat(command: '(echo $CMD | jq '.command')') { command updatedAt count } } }'
    set -l GQL_QUERY (jq -n --arg query $MUTATION '{$query, "variables": {}}')

    # Silent curl to home server
    curl -H 'Content-Type: application/json' --data-raw "$GQL_QUERY" localhost:7749/graphql 1>/dev/null 2>/dev/null
end
