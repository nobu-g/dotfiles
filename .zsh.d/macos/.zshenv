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

# evaluate contents of /etc/paths.d and /etc/manpath.d instead of path_helper
path=($(cat /etc/paths.d/*) ${path})
manpath=($(cat /etc/manpaths.d/*) ${manpath})

## PyCharm
if [[ -e /Applications/PyCharm.app ]]; then
  path=(/Applications/PyCharm.app/Contents/MacOS(N-/) ${path})
fi

## TexLive
if [[ -e /Library/TeX ]]; then
  path=(/Library/TeX/Distributions/Programs/texbin(N-/) ${path})
  manpath=(/Library/TeX/Documentation/texmf-dist-doc/man(N-/) ${manpath})
  infopath=(/Library/TeX/Documentation/texmf-dist-doc/info(N-/) ${infopath})
fi

## ghq
export GHQ_ROOT="${HOME}/Projects"
