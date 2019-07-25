case "$OSTYPE" in
    darwin*)
        export REPODIR="$HOME/Repos"
        export GOPATH="$HOME/go"
        export PATH=$PATH:/usr/local/opt/go/libexec/bin
        ;;
    linux-gnu*)
        export GOPATH="$HOME/go"
        export PATH=$PATH:$GOPATH/bin
        export PAGER="less"
        export VISUAL="vi"
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

gittagsummary ()
{
    awk 'NR==1{last=$1} NR>1{print last".."$1; last=$1} END{print last"..HEAD"}' | xargs -t -I {} git diff --shortstat {}
}

host ()
{
    if [ -z "$1" ]
    then
        echo "Usage: host [host]"
        return
    fi
    /usr/bin/host $1
    whois $(dig +short $1) | grep -e "Organization\|org.*name"
    echo -n "$1 DNS SOA is "
    dig +short $1 SOA | sed 's/[0-9 ]*$//'
}

if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
    source $HOME/.bashrc
fi
