function fgbg
    if test -z (commandline)
        if test (jobs | count) != 0
            fg
        end
    else
        clear
        commandline ""
    end
end

bind \cz fgbg

set FZF_DEFAULT_COMMAND 'rg --files --hidden --no-ignore-vcs -g "!{node_modules,.git}"'
set FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set FZF_ALT_C_COMMAND "fd --type d --hidden --exclude .git"
set FZF_DEFAULT_OPTS "--color=dark --layout=reverse --margin=1,1 --color=fg:15,bg:-1,hl:1,fg+:#ffffff,bg+:0,hl+:1 --color=info:8,pointer:12,marker:4,spinner:11,header:-1"

bind \ct fzf-cd-widget
