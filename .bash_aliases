case "$OSTYPE" in
    darwin*)
        alias ls='ls -GFh'
        ;;
    linux-gnu*)
        ;;
    openbsd*)
        alias vi='vim'
        ;;
esac

alias grep='grep --color=auto'
alias dotfile='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias mosh='mosh -p 60000:60020'
alias wanip='dig +short myip.opendns.com @resolver1.opendns.com'

# analogist.net web items
alias hugoclean='hugo --cleanDestinationDir'
alias affinesync="rsync -a -z -v -n --delete --exclude '.*DS_Store' $REPODIR/analogist_net/public/ affine:/srv/www/analogist/"
alias affinesync_EXEC="rsync -a -z --delete --exclude '.*DS_Store' $REPODIR/analogist_net/public/ affine:/srv/www/analogist/"
