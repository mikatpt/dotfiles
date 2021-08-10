export EDITOR='code'

cs() { cd "$1" && ls -A; }
sc() { cd .. && ls -A; }
csa() { cd "$1" && ls -Ahl; }
sca() { cd  .. && ls -Ahl; }

# cd to selected directory using fzf
fda() {
    local dir
    dir=$(fd --type d --hiden --exclude .git | fzf +m) &&
    cd "$dir"
}

fdr() {
    local declare dirs=()
    get_parent_dirs() {
        if [[ -d "${1}" ]]; then dirs+=("$1"); else return; fi
        if [[ "${1}" == '/' ]]; then
            for _dir in "${dirs[@]}"; do echo $_dir; done
        else
            get_parent_dirs $(dirname "$1")
        fi
    }
    local DIR=$(get_parent_dirs $(grealpath "${1:-$PWD}") | fzf-tmux --tac)
    cd "$DIR"
}

alias la='ls -A'
alias lah='ls -Ahl'
alias notes='nvim ~/notes'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias ffs='sudo !!'
alias :q='exit'

alias gcm='git commit -m'
alias co='git checkout'
alias s='git status'
alias st='git stash'
alias sd='git stash drop' 
alias sp='git stash pop'
alias sa='git stash apply'
alias sl='git stash list'

alias fco='fuzzyhub checkout'        # checkout a branch. Specifying branch name will use git checkout instead.
alias far='fuzzyhub add-remote'      # add git remote
alias fsm='fuzzyhub sync-master'     # sync local, origin and upstream master
alias fpr='fuzzyhub view-pr'         # view pull request(s) on github
alias fm='fuzzyhub view-master'      # view master on github. ctrl-t to specify file(s)
alias fl='fuzzyhub view-local'       # view local branch on github. ctrl-t to specify file(s)


