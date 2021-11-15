function testing -e fish_postexec
    curl --data "{\"command\":\"$argv\"}" --header 'Content-Type: application/json' http://localhost:7749/stats
end
