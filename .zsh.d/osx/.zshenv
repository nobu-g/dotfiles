# PATH

## ignore /etc/zprofile, /etc/zshrc, /etc/zlogin, and /etc/zlogout
unsetopt GLOBAL_RCS
## copied from /etc/zprofile
## system-wide environment settings for zsh
if [[ -x /usr/libexec/path_helper ]]; then
  eval `/usr/libexec/path_helper -s`
fi

## GNU/Linux 版コマンドを使えるように
path=(
  ${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin(N-/) # coreutils
  ${HOMEBREW_PREFIX}/opt/ed/libexec/gnubin(N-/) # ed
  ${HOMEBREW_PREFIX}/opt/findutils/libexec/gnubin(N-/) # findutils
  ${HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnubin(N-/) # sed
  ${HOMEBREW_PREFIX}/opt/gnu-tar/libexec/gnubin(N-/) # tar
  ${HOMEBREW_PREFIX}/opt/grep/libexec/gnubin(N-/) # grep
  ${path}
)
manpath=(
  ${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnuman(N-/) # coreutils
  ${HOMEBREW_PREFIX}/opt/ed/libexec/gnuman(N-/) # ed
  ${HOMEBREW_PREFIX}/opt/findutils/libexec/gnuman(N-/) # findutils
  ${HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnuman(N-/) # sed
  ${HOMEBREW_PREFIX}/opt/gnu-tar/libexec/gnuman(N-/) # tar
  ${HOMEBREW_PREFIX}/opt/grep/libexec/gnuman(N-/) # grep
  ${manpath}
)

## other tool paths
path=(
  ${HOME}/.nodebrew/current/bin(N-/)  # nodebrew
  /opt/X11/bin(N-/)  # X11
  ${path}
)

## TexLive 2019
if [ -e ${HOMEBREW_PREFIX}/texlive/2019/bin/x86_64-darwin ]; then
  export PATH=${HOMEBREW_PREFIX}/texlive/2019/bin/x86_64-darwin:$PATH
  export INFOPATH=${HOMEBREW_PREFIX}/texlive/2019/texmf-dist/doc/info:$INFOPATH
  export MANPATH=${HOMEBREW_PREFIX}/texlive/2019/texmf-dist/doc/man:$MANPATH
fi

# pyenv
export PYENV_ROOT=/usr/local/var/pyenv
export PATH=$PYENV_ROOT/bin:$PATH
