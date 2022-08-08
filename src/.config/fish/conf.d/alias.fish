# Edit config
abbr -ag ez 'nvim ~/config'
abbr -ag ea 'nvim ~/config/src/.config/fish/conf.d/alias.fish'
abbr -ag sz 'exec fish'

function notes; nvim ~/notes/notes.md; end;
function repl; nvim ~/repl/src/main.rs; end;
abbr -ag py 'python3.9'

# Navigation
abbr -ag ls 'exa'
abbr -ag la 'exa -a'
abbr -ag lah 'exa -la'
abbr -ag lat 'exa -laT'
function cs; cd $argv; exa -a; end
function sc; cd ..; exa -a; end
function csa; cd $argv; exa -al; end
function sca; cd ..; exa -al; end
function cat --wraps=cat; batcat $argv; end
function fda
    set -l dir (fd --type d --hidden --exclude .git | fzf +m)
    cd $dir
end

# Tmux
function t --wraps=tmux; tmux; end
abbr -ag ta 'tmux attach'
abbr -ag tn 'tmux new-session'

abbr -ag .. 'cd ..'
abbr -ag ... 'cd ../..'
abbr -ag .... 'cd ../../..'
abbr -ag ffs 'eval sudo $history[1]'
function :q --wraps=exit; exit; end
function :wq --wraps=exit; exit; end

# Git
abbr -ag cm 'git commit'
abbr -ag ga 'git add'
abbr -ag gp 'git push'
abbr -ag push 'git push'
abbr -ag pull 'git pull'
abbr -ag gr 'git reset'
abbr -ag b 'git branch'
abbr -ag co 'git checkout'
abbr -ag s 'git status'
abbr -ag st 'git stash'
abbr -ag sd 'git stash drop'
abbr -ag sp 'git stash pop'
abbr -ag sa 'git stash apply'
abbr -ag sl 'git stash list'
abbr -ag merge 'git merge'
abbr -ag mergetool 'git mergetool'
abbr -ag gmt 'git mergetool'
abbr -ag rebase 'git rebase'
