# LANG
export LANG=ja_JP.UTF-8
export LC_CTYPE=${LANG}
export LC_ALL=${LANG}

# PATH(GENERAL)
typeset -U path
path=(
    $HOME/.local/bin(N-/)
    $HOME/local/bin(N-/)
    $HOME/usr/bin(N-_)
    /bin(N-/)
    /usr/local/bin(N-/)
    /usr/local/sbin(N-/)
    /sbin(N-/)
    /bin(N-/)
    /usr/sbin(N-/)
    /usr/bin(N-/)
)


# PATH FOR MAN(MANUAL)
typeset -U manpath
manpath=(
    /usr/local/share/man(N-/)
    /usr/share/man(N-/)
)


# PATH(SUDO)
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


# EDITOR
export EDITOR=emacsclient  # use emacs


# LOAD INDIVIDUAL SETTING
ZSHHOME="${HOME}/dotfiles/.zsh.d"

case "${OSTYPE}" in
linux*|cygwin*)
    if [ -e ${ZSHHOME}/.zshenv.basil ]; then
        source ${ZSHHOME}/.zshenv.basil
    fi
    ;;
freebsd*|darwin*)
    if [ -e ${ZSHHOME}/.zshenv.mac ]; then
        source ${ZSHHOME}/.zshenv.mac
    fi
    ;;
esac
