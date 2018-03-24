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

# analogist.net web items
alias hugoclean='hugo --cleanDestinationDir'
alias affinesync="gsutil -m rsync -r -d -n -x '\.*DS_Store' /Users/james/Repos/analogist_net/public/ gs://analogist.net/"
alias affinesync_EXEC="gsutil -m rsync -r -d -x '\.*DS_Store' /Users/james/Repos/analogist_net/public/ gs://analogist.net/"
# alias affinesync="rsync -a -z -v -n --delete --exclude '.*DS_Store' $REPODIR/analogist_net/public/ affine:/srv/www/analogist/"
# alias affinesync_EXEC="rsync -a -z --delete --exclude '.*DS_Store' $REPODIR/analogist_net/public/ affine:/srv/www/analogist/"
