case "$OSTYPE" in
    darwin*)
        export REPODIR="$HOME/Repos"
        gsed 's/^\(\s*PKCS11Provider \/usr\/lib\/x86_64-linux-gnu\/opensc-pkcs11\.so\)/#\1/' $HOME/.ssh/configGitServers.template > $HOME/.ssh/configGitServers
        ;;
    linux-gnu*)
        export PAGER="less"
        export VISUAL="vi"
        sed 's/^\(\s*PKCS11Provider \/usr\/local\/lib\/opensc-pkcs11\.so\)/#\1/' $HOME/.ssh/configGitServers.template > $HOME/.ssh/configGitServers
        ;;
    openbsd*)
        export PAGER='less'
        ;;
esac

export GOPATH="$HOME/go"
export PATH=$PATH:$GOPATH/bin

if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
    source $HOME/.bashrc
fi
