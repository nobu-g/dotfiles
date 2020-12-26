# PATH

## ignore /etc/zprofile, /etc/zshrc, /etc/zlogin, and /etc/zlogout
unsetopt GLOBAL_RCS

## GNU/Linux 版コマンドを使えるように
path=(
  ${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin(N-/)
  ${HOMEBREW_PREFIX}/opt/ed/libexec/gnubin(N-/)
  ${HOMEBREW_PREFIX}/opt/findutils/libexec/gnubin(N-/)
  ${HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnubin(N-/)
  ${HOMEBREW_PREFIX}/opt/gnu-tar/libexec/gnubin(N-/)
  ${HOMEBREW_PREFIX}/opt/grep/libexec/gnubin(N-/)
  ${HOMEBREW_PREFIX}/opt/make/libexec/gnubin(N-/)
  ${HOMEBREW_PREFIX}/opt/gawk/libexec/gnubin(N-/)
  ${HOMEBREW_PREFIX}/opt/gnu-which/libexec/gnubin(N-/)
  ${path}
)
manpath=(
  ${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnuman(N-/)
  ${HOMEBREW_PREFIX}/opt/ed/libexec/gnuman(N-/)
  ${HOMEBREW_PREFIX}/opt/findutils/libexec/gnuman(N-/)
  ${HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnuman(N-/)
  ${HOMEBREW_PREFIX}/opt/gnu-tar/libexec/gnuman(N-/)
  ${HOMEBREW_PREFIX}/opt/grep/libexec/gnuman(N-/)
  ${HOMEBREW_PREFIX}/opt/make/libexec/gnuman(N-/)
  ${HOMEBREW_PREFIX}/opt/gawk/libexec/gnuman(N-/)
  ${HOMEBREW_PREFIX}/opt/gnu-which/libexec/gnuman(N-/)
  ${manpath}
)

# pyenv
export PYENV_ROOT=/usr/local/var/pyenv

## other tool paths
path=(
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

## ghq
export GHQ_ROOT=${HOME}/Projects
