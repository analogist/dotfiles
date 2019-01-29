case "$OSTYPE" in
    darwin*)
        alias ls='ls -GFh'
        alias ssh="gpg-connect-agent updatestartuptty /bye >/dev/null; ssh"
        ;;
    linux-gnu*)
        ;;
    openbsd*)
        alias vi='vim'
        ;;
esac

alias dotfile='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias mosh='gpg-connect-agent updatestartuptty /bye >/dev/null; mosh -p 60000:60020'
alias wanip='dig +short myip.opendns.com @resolver1.opendns.com'
alias sshf='ssh -nNTL'

# analogist.net web items
alias hugoclean='hugo --cleanDestinationDir'
