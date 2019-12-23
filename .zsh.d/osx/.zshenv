# PATH

## ignore /etc/zprofile, /etc/zshrc, /etc/zlogin, and /etc/zlogout
unsetopt GLOBAL_RCS
## copied from /etc/zprofile
## system-wide environment settings for zsh
if [ -x /usr/libexec/path_helper ]; then
    eval `/usr/libexec/path_helper -s`
fi

## GNU/Linux 版コマンドを使えるように
path=(
    /usr/local/opt/coreutils/libexec/gnubin(N-/) # coreutils
    /usr/local/opt/ed/libexec/gnubin(N-/) # ed
    /usr/local/opt/findutils/libexec/gnubin(N-/) # findutils
    /usr/local/opt/gnu-sed/libexec/gnubin(N-/) # sed
    /usr/local/opt/gnu-tar/libexec/gnubin(N-/) # tar
    /usr/local/opt/grep/libexec/gnubin(N-/) # grep
    ${path}
)
manpath=(
    /usr/local/opt/coreutils/libexec/gnuman(N-/) # coreutils
    /usr/local/opt/ed/libexec/gnuman(N-/) # ed
    /usr/local/opt/findutils/libexec/gnuman(N-/) # findutils
    /usr/local/opt/gnu-sed/libexec/gnuman(N-/) # sed
    /usr/local/opt/gnu-tar/libexec/gnuman(N-/) # tar
    /usr/local/opt/grep/libexec/gnuman(N-/) # grep
    ${manpath}
)

## texlive
PATH=/usr/local/texlive/2018/bin/x86_64-darwin:$PATH
## nodebrew
PATH=$HOME/.nodebrew/current/bin:$PATH

# pyenv
export PYENV_ROOT=/usr/local/var/pyenv
export PATH="$PYENV_ROOT/bin:$PATH"
