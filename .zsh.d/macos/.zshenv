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

# evaluate contents of /etc/paths.d and /etc/manpaths.d instead of path_helper.
# Use an anon function so the temporaries do not leak into the global scope.
# (N) avoids "no matches found" on hosts without these dirs (no_nomatch is not
# set yet in .zshenv); the emptiness guard keeps `cat` from blocking on stdin
# when the glob matches nothing; "${(f)...}" splits on newlines only so entries
# containing spaces survive.
() {
  local -a files
  files=(/etc/paths.d/*(N))
  (( ${#files} )) && path=("${(f)$(cat -- ${files})}" ${path})
  files=(/etc/manpaths.d/*(N))
  (( ${#files} )) && manpath=("${(f)$(cat -- ${files})}" ${manpath})
}

## TexLive
if [[ -e /Library/TeX ]]; then
  path=(/Library/TeX/Distributions/Programs/texbin(N-/) ${path})
  manpath=(/Library/TeX/Documentation/texmf-dist-doc/man(N-/) ${manpath})
  infopath=(/Library/TeX/Documentation/texmf-dist-doc/info(N-/) ${infopath})
fi

## ghq
export GHQ_ROOT="${HOME}/Projects"
