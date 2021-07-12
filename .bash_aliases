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

alias dotfile='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias wanip='dig +short o-o.myaddr.l.google.com @ns1.google.com TXT'
alias wanip4='wanip -4'
alias wanip6='wanip -6'
alias clockrun='TZ="America/Los_Angeles" watch -n 0.1 date +"%T.%N"'

# analogist.net web items
alias exifstrip='exiftool -gps:all= -xmp:gps*= -lens*= -model='
alias hugoclean='hugo --cleanDestinationDir'
