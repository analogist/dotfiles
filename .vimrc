set history=500
filetype plugin on 
filetype indent on
set autoread
if has('gui_running')
    set guioptions-=T
    if has('gui_win32')
        set guifont=Inconsolata:h12
    endif
endif

set nobackup
set nowritebackup
if has('gui_win32')
    set noswapfile
endif

set backspace=indent,eol,start
set expandtab
set shiftwidth=4
set softtabstop=4
set autoindent

syntax enable
set hlsearch
set incsearch
set encoding=utf8
set ffs=unix,dos,mac
set wildmenu
set so=7

set ruler
set number
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif
try
    colorscheme desert
catch
endtry

nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z
