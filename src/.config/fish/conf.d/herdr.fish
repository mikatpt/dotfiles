function home_start --description 'Bootstrap the herdr "home" workspace with the homeserver listener'
    set -l pane (herdr workspace create --cwd ~/coding/homeserver --label home --no-focus | jq -r '.result.root_pane.pane_id')
    herdr pane run $pane 'cargo run -r --bin listener'
end
