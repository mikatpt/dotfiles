# Edit config
abbr -ag ez 'nvim ~/config +"PackerLoad dashboard-nvim" +Dashboard +NvimTreeOpen'
abbr -ag ea 'nvim ~/config/src/.config/fish/conf.d/alias.fish'
abbr -ag sz 'exec fish'

function notes; eval 'nvim ~/notes +"PackerLoad dashboard-nvim nvim-web-devicons" +Dashboard +NvimTreeOpen'; end;

# Navigation
function cs; cd $argv; ls -A; end
function sc; cd ..; ls -A; end
function csa; cd $argv; ls -Ahl; end
function sca; cd ..; ls -Ahl; end
function la; ls -A $argv; end
function lah; ls -Ahl $argv; end

# Tmux
abbr -ag t 'tmux'
abbr -ag ta 'tmux attach'
abbr -ag tn 'tmux new-session'

abbr -ag .. 'cd ..'
abbr -ag ... 'cd ../..'
abbr -ag .... 'cd ../../..'
abbr -ag ffs 'eval sudo $history[1]'
abbr -ag :q 'exit'

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
