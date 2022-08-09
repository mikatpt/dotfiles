export EDITOR='nvim'
set -o ignoreeof    # ignore C-D

# use nvim for everything
alias vi='nvim'
alias vim='nvim'
alias v='nvim'

# Shortcuts to config editing
alias ez='$EDITOR ~/.zshrc'
alias ea='$EDITOR ~/config/src/.alias.zsh'
alias el='$EDITOR ~/.local.zsh'
alias sz='exec zsh'

cs() { cd "$1" && ls -AG; }
sc() { cd .. && ls -AG; }
csa() { cd "$1" && ls -AGhl; }
sca() { cd  .. && ls -AGhl; }

# cd to selected directory using fzf
fda() {
    local dir
    dir=$(fd --type d --hidden --exclude .git | fzf +m) &&
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

squash() {
    local RED='\033[0;31m'
    local NC='\033[0m'
    local SHA="$1"
    if [[ -z "$SHA" ]]; then
        echo "${RED}error: Provide a commit SHA or HEAD number to squash to.${NC}";
    else
        if read -q "?hard squash to commit after ${SHA} (y/n) ?"; then
            git reset --hard "$SHA" && git merge --squash HEAD@{1} && git commit
        fi
    fi
}
bd() {
    git diff --name-only --line-prefix=`git rev-parse --show-toplevel`/ | xargs bat --diff
}

alias cat='bat'
alias ls='ls -G'
alias la='ls -AG'
alias lah='ls -AGhl'
alias notes='nvim ~/notes'
alias repl='nvim ~/repl/src/main.rs'
alias rm='rm'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias ffs='sudo !!'
alias :q='exit'

alias cm='git commit'
alias ga='git add'
alias gp='git push'
alias gpo='git push --set-upstream origin `git rev-parse --abbrev-ref HEAD`'
alias push='git push'
alias pull='git pull'
alias pullup='git pull upstream master --rebase'
alias gr='git reset'
alias b='git branch'
alias co='git checkout'
alias s='git status'
alias st='git stash'
alias sd='git stash drop' 
alias sp='git stash pop'
alias sa='git stash apply'
alias sl='git stash list'
alias merge='git merge'
alias gmt='git mergetool'
alias mergetool='git mergetool'
alias rebase='git rebase'

alias pingg='ping www.google.com'    # See network speed against google.com
alias myip="ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"
