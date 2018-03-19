case "$OSTYPE" in
    darwin*)
        export GPG_TTY=$(tty)
        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
        if ! pgrep -x -u $USER "gpg-agent" >/dev/null 2>&1; then
            gpg-connect-agent /bye >/dev/null 2>&1
        fi
        export GIT_SSH_COMMAND="gpg-connect-agent updatestartuptty /bye >/dev/null; ssh"
        export REPODIR="$HOME/Repos"
        export GOPATH="$HOME/go"
        export PATH=$PATH:/usr/local/opt/go/libexec/bin
        ;;
    linux-gnu*)
        export GOPATH="$HOME/go"
        ;;
    openbsd*)
        export PAGER='less'
        ;;
esac

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

host ()
{
    if [ -z "$1" ]
    then
        echo "Usage: host [host]"
        return
    fi
    /usr/bin/host $1
    echo -n "$1 is hosted by "
    whois $(dig +short $1) | grep "Organization" | sed 's/^Organization: *//'
    echo -n "$1 DNS SOA is "
    dig +short $1 SOA | sed 's/[0-9 ]*$//'
}

if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
    source $HOME/.bashrc
fi
