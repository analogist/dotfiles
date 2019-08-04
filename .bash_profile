case "$OSTYPE" in
    darwin*)
        export REPODIR="$HOME/Repos"
        gsed 's/^\(\s*PKCS11Provider \/usr\/lib\/x86_64-linux-gnu\/opensc-pkcs11\.so\)/#\1/' $HOME/.ssh/configGitServers.template > $HOME/.ssh/configGitServers
        ;;
    linux-gnu*)
        export PAGER="less"
        export VISUAL="vi"
        export PATH=$PATH:/usr/local/go/bin
        sed 's/^\(\s*PKCS11Provider \/usr\/local\/lib\/opensc-pkcs11\.so\)/#\1/' $HOME/.ssh/configGitServers.template > $HOME/.ssh/configGitServers
        ;;
    openbsd*)
        export PAGER='less'
        ;;
esac

export GOPATH="$HOME/go"

if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
    source $HOME/.bashrc
fi
