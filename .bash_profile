case "$OSTYPE" in
    darwin*)
        export REPODIR="$HOME/Repos"
        ;;
    linux-gnu*)
        export PAGER="less"
        export VISUAL="vi"
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
