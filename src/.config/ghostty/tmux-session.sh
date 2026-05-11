#!/bin/zsh
TMUX=/opt/homebrew/bin/tmux
SESSION="main"

if $TMUX has-session -t "$SESSION" 2>/dev/null; then
    exec $TMUX attach-session -t "$SESSION"
fi

$TMUX new-session -d -s "$SESSION"
$TMUX new-window -t "$SESSION"
$TMUX select-window -t "$SESSION:1"
$TMUX attach-session -t "$SESSION"
exec zsh -l
