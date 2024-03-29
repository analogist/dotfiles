case "$OSTYPE" in
    darwin*)
        export PATH="/opt/homebrew/bin${PATH+:$PATH}"
        export SSH_AUTH_SOCK="$HOME/.ssh/yubikey-agent.sock"
        export REPODIR="$HOME/Repos"
        [ ! -f "$HOME/.ssh/configGitServers" ] && gsed 's/^\(\s*PKCS11Provider .*$\)/#\1/' $HOME/.ssh/configGitServers.template > $HOME/.ssh/configGitServers
        ;;
    linux-gnu*)
        export PAGER="less"
        export VISUAL="vi"
        export PATH=$PATH:/usr/local/go/bin
        [ ! -f "$HOME/.ssh/configGitServers" ] && sed 's/^\(\s*PKCS11Provider \/usr\/local\/lib\/opensc-pkcs11\.so\)/#\1/' $HOME/.ssh/configGitServers.template > $HOME/.ssh/configGitServers
        ;;
    openbsd*)
        export PAGER='less'
        ;;
esac

export GOPATH="$HOME/go"
export GO111MODULE=on

if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
    source $HOME/.bashrc
fi

if [ -f "$HOME/.envcreds" ]; then
    source $HOME/.envcreds
fi
