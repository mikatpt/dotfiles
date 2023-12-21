# Edit config
abbr -ag ez 'nvim ~/config'
abbr -ag ea 'nvim ~/config/src/.config/fish/conf.d/alias.fish'
abbr -ag sz 'exec fish'

function notes; nvim ~/notes/notes.md; end;
function repl; nvim ~/repl/src/main.rs; end;
abbr -ag py 'ipython'

# Navigation
abbr -ag ls 'eza'
abbr -ag la 'eza -a'
abbr -ag lah 'eza -la'
abbr -ag lat 'eza -laT'
function cs; cd $argv; eza -a; end
function sc; cd ..; eza -a; end
function csa; cd $argv; eza -al; end
function sca; cd ..; eza -al; end
function cat --wraps=cat; bat $argv; end
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

function __info; set_color green; echo $argv; set_color normal; end
function __warn; set_color yellow; echo $argv; set_color normal; end
function __error; set_color red; echo $argv; set_color normal; end
function __debug; set_color magenta; echo $argv; set_color normal; end

function pullup
    set -l MAIN (git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)
    set -l BRANCH (git rev-parse --abbrev-ref HEAD)
    set -l UPSTREAM_EXISTS (git remote | grep upstream)
    __info "Updating $MAIN"

    # Just update origin if upstream doesn't exist.
    if test -z $UPSTREAM_EXISTS
        if test $MAIN = $BRANCH
            git pull origin $MAIN --rebase && git push origin $MAIN
        else
            git fetch origin $MAIN:$MAIN
            and __info "Rebasing $BRANCH"
            and git rebase $MAIN
        end
        return
    end

    if test $MAIN = $BRANCH
        git pull upstream $MAIN --rebase && git push origin $MAIN
    else
        git fetch upstream $MAIN:$MAIN
        and git push origin $MAIN:$MAIN
        and __info "Rebasing $BRANCH"
        and git rebase $MAIN
    end
end

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
