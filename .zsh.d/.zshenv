# LANG
export LANG=ja_JP.UTF-8
export LC_CTYPE=${LANG}
export LC_ALL=${LANG}


# PATH(GENERAL)
## -U: 重複したパスを登録しない
typeset -U path
path=(
    $HOME/.local/bin(N-/)
    $HOME/local/bin(N-/)
    $HOME/usr/bin(N-/)
    /usr/local/bin(N-/)
    /usr/local/sbin(N-/)
    /usr/bin(N-/)
    /usr/sbin(N-/)
    /bin(N-/)
    /sbin(N-/)
    # "$path[@]"
)

# PATH FOR MAN(MANUAL)
typeset -U manpath
manpath=(
    /usr/local/share/man(N-/)
    /usr/share/man(N-/)
)


# PATH(SUDO)
## -x: export SUDO_PATHも一緒に行う。
## -T: SUDO_PATHとsudo_pathを連動する。
typeset -xT SUDO_PATH sudo_path
typeset -U sudo_path
sudo_path=({,/usr/pkg,/usr/local,/usr}/sbin(N-/))

if [ $(id -u) -eq 0 ]; then  # root user
    path=($sudo_path $path)
fi


## lv setting
export LV="-c -l"
## less setting (https://qiita.com/delphinus/items/b04752bb5b64e6cc4ea9)
export LESS="-i -M -R -x4"
# LESS="$LESS -X -F"
export LESSCHARSET='utf-8'
if [[ -e /usr/local/bin/src-hilite-lesspipe.sh ]]; then
    export LESSOPEN="| /usr/local/bin/src-hilite-lesspipe.sh %s"
fi

if [[ -e $HOME/usr/bin/src-hilite-lesspipe.sh ]]; then
    export LESSOPEN="| $HOME/usr/bin/src-hilite-lesspipe.sh %s"
fi

# PAGER
export PAGER="less"


# EDITOR
export EDITOR=emacsclient  # use emacs


case "${OSTYPE}" in
linux*|cygwin*)
    ZSHHOME="${HOME}/dotfiles/.zsh.d/linux"
    ;;
freebsd*|darwin*)
    ZSHHOME="${HOME}/dotfiles/.zsh.d/osx"
    ;;
esac

source ${ZSHHOME}/.zshenv
