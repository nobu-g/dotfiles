# PATH

## ignore /etc/zprofile, /etc/zshrc, /etc/zlogin, and /etc/zlogout
unsetopt GLOBAL_RCS

## GNU/Linux 版コマンドを使えるように
path=(
  ${HOMEBREW_PREFIX}/opt/{coreutils,ed,findutils,gnu-sed,gnu-tar,grep,make,gawk,gnu-which}/libexec/gnubin(N-/)
  ${path}
)
manpath=(
  ${HOMEBREW_PREFIX}/opt/{coreutils,ed,findutils,gnu-sed,gnu-tar,grep,make,gawk,gnu-which}/libexec/gnuman(N-/)
  ${manpath}
)

# pyenv
export PYENV_ROOT=/usr/local/var/pyenv

## other tool paths
path=(
  /opt/X11/bin(N-/)  # X11
  ${PYENV_ROOT}/shims(N-/)
  /Library/Apple/usr/bin
  ${path}
)

## TexLive
if [[ -e /Library/TeX ]]; then
  path=(/Library/TeX/texbin(N-/) ${path})
  manpath=(/Library/TeX/Documentation/texmf-dist-doc/man(N-/) ${manpath})
  infopath=(/Library/TeX/Documentation/texmf-dist-doc/info(N-/) ${infopath})
fi

## ghq
export GHQ_ROOT=${HOME}/Projects
