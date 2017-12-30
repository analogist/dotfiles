case "$OSTYPE" in
    darwin*)
        PS1='\u@\h:\W\$ '
        export GPG_TTY=$(tty)
        alias ls='ls -GFh'

        export REPODIR="$HOME/Repos"
        ;;
    linux-gnu*)
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

gsmd5 ()
{
    awk 'BEGIN { \
    decodehash = "base64 -d | xxd -p | tr -d \"\\n\""; \
    truncname = "sed \"s/gs:\/\/[a-z0-9_.\-]*\///\" | sed \"s/:$//\"" } \
    /Hash \(md5\)/ { print $3 | decodehash; close(decodehash); \
        printf "  %s\n",fname | truncname; close(truncname) } \
    /^gs:\/\// { fname = $0 }'
}

computestat ()
{
    awk '{ sum=sum+$1 ; sumX2+=(($1)^2)} END { avg=sum/NR; printf "Average: %f. Standard Deviation: %f \n", avg, sqrt(sumX2/(NR-1) - 2*avg*(sum/(NR-1)) + ((NR*(avg^2))/(NR-1))) }'
}

if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
    source $HOME/.bashrc
fi
