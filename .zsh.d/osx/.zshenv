# PATH

## ignore /etc/zprofile, /etc/zshrc, /etc/zlogin, and /etc/zlogout
unsetopt GLOBAL_RCS

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

# pyenv
export PYENV_ROOT=/usr/local/var/pyenv

## other tool paths
path=(
  ${HOME}/.nodebrew/current/bin(N-/)  # nodebrew
  /opt/X11/bin(N-/)  # X11
  ${PYENV_ROOT}/shims(N-/)
  ${path}
)

## TexLive
if [[ -e /Library/TeX ]]; then
  export PATH=/Library/TeX/texbin:${PATH}
  export INFOPATH=/Library/TeX/Documentation/texmf-dist-doc/info:${INFOPATH}
  export MANPATH=/Library/TeX/Documentation/texmf-dist-doc/man:${MANPATH}
fi
