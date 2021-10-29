export EDITOR='nvim'
set -o ignoreeof

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

alias ls='ls -G'
alias la='ls -AG'
alias lah='ls -AGhl'
alias notes='nvim ~/notes'
alias rm='rm -i'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias ffs='sudo !!'
alias :q='exit'

alias cm='git commit'
alias ga='git add'
alias gp='git push'
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

alias pingg='ping www.google.com'    # See network speed against google.com
alias myip="ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"
