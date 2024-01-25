# profiling (set ZPROF environment variable to profile)
if (( ${+ZPROF} )); then
  zmodload zsh/zprof && zprof
fi

export ZDOTDIR="${ZDOTDIR:-${HOME}/.zsh}"
SELF="${(%):-%N}"
DOTPATH="$(dirname "${SELF:A:h}")"

# LANG
export LANG=ja_JP.UTF-8
export LANGUAGE=en_US

# PATH Settings
## Zsh synchronizes path, manpath, and fpath with PATH, MANPATH, and FPATH respectively
## -g: do not restrict parameter to local scope
## -a: specify that arguments refer to arrays
## -U: keep array values unique
## -x: export parameter
## -T: tie scalar to array
## Exclude the paths under $HOME since they will be added later.
## (N-/): Glob Qualifiers
### N: use NULL_GLOB
### -: follow symlinks toggle
### /: directories
typeset -gaU path manpath fpath
typeset -gaxUT INFOPATH infopath
typeset -gaxUT SUDO_PATH sudo_path
# PATH
path=(
  {/usr{/local,},}/{bin,sbin}(N-/)
  ${path:#${HOME}/*}(N-/)
)
# MANPATH
manpath=(
  /usr{/local,}/share/man(N-/)
  ${manpath:#${HOME}/*}(N-/)
)
# INFOPATH
infopath=(
  /usr{/local,}/share/info(N-/)
  ${infopath:#${HOME}/*}(N-/)
)
# FPATH
fpath=(
  /usr{/local,}/share/zsh/{site-functions,vendor-completions}(N-/)
  ${fpath:#${HOME}/*}(N-/)
)
# PATH (SUDO)
sudo_path=({,/usr/pkg,/usr/local,/usr}/sbin(N-/))

if [[ $(id -u) -eq 0 ]]; then  # root user
  path=(${sudo_path} ${path})
fi

# search HOMEBREW_PREFIX from candidates because the prefix varies depending on the environment
# note that the former the candidate, the higher the priority
for prefix in "${HOME}/.linuxbrew" "/home/linuxbrew/.linuxbrew" "/opt/homebrew" "/usr/local"; do
  if [[ -x "${prefix}/bin/brew" ]]; then
    export HOMEBREW_PREFIX="${prefix:A}"  # canonicalize
    export HOMEBREW_CELLAR="${HOMEBREW_PREFIX}/Cellar"
    export HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}/Homebrew"
    break
  fi
done

# Python
export PYTHONUSERBASE="${HOME}/.local"
if [[ -d "${HOME}/.virtualenvs" ]]; then
  export WORKON_HOME="${HOME}/.virtualenvs"
else
  export PIPENV_VENV_IN_PROJECT=true
fi
export PYTEST_ADDOPTS="-v -s --ff"

# zmv
autoload -Uz zmv

ZBASEDIR="${DOTPATH}/.zsh.d"
case "${OSTYPE}" in
linux*|cygwin*)
  ZENVDIR="${ZBASEDIR}/linux"
  ;;
freebsd*|darwin*)
  ZENVDIR="${ZBASEDIR}/macos"
  ;;
esac

# XDG Base Directory Specification
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_RUNTIME_DIR="/run/user/$(id -u)"  # https://serverfault.com/a/887298

# load environment specific configurations
source "${ZENVDIR}/.zshenv"

# XDG Base Directory Specification
export XDG_DATA_DIRS=${HOMEBREW_PREFIX}/share:/usr/local/share:/usr/share
export XDG_CONFIG_DIRS="/etc/xdg"  # default

if [[ -n ${HOMEBREW_PREFIX} ]]; then
  path=(${HOMEBREW_PREFIX}/{bin,sbin}(N-/) ${path})
  manpath=(${HOMEBREW_PREFIX}/share/man(N-/) ${manpath})
  infopath=(${HOMEBREW_PREFIX}/share/info(N-/) ${infopath})
  fpath=(${HOMEBREW_PREFIX}/share/zsh/{functions,site-functions}(N-/) ${fpath})
fi

# Ruby
if [[ -d ${HOMEBREW_PREFIX}/opt/ruby ]]; then
  path=(${HOMEBREW_PREFIX}/opt/ruby/bin(N-/) ${path})
fi

# Java
if [[ -d ${HOMEBREW_PREFIX}/opt/openjdk ]]; then
  path=(${HOMEBREW_PREFIX}/opt/openjdk/bin(N-/) ${path})
fi

# Golang
if [[ -d ${HOME}/.go ]]; then
  export GOPATH="${HOME}/.go"
  path=(${GOPATH}/bin(N-/) ${path})
fi

# RubyGems
if [[ -d ${HOME}/.gem/ruby ]]; then
  for p in ${HOME}/.gem/ruby/*/bin; do
    path=(${p}(N-/) ${path})
  done
fi

path=(
  ${HOME}/.cargo/bin(N-/)  # Rust
  ${HOME}/.poetry/bin(N-/)  # Poetry
  ${HOME}/.config/emacs/bin(N-/)  # doom-emacs
  ${path}
)

# general paths under $HOME
path=(
  ${HOME}{/.local,/local,/usr}/bin(N-/)
  ${path}
)
manpath=(
  ${HOME}{/.local,/local,/usr}/share/man(N-/)
  ${manpath}
)
infopath=(
  ${HOME}{/.local,/local,/usr}/share/info(N-/)
  ${infopath}
)
fpath=(
  ${HOME}/.zfunc(N-/)
  ${HOME}{/.local,/local,/usr}/share/zsh/{functions,site-functions}(N-/)
  ${fpath}
)

# my scripts and functions
path=(${HOME}/scripts(N-/) ${path})
fpath=(
  ${ZENVDIR}/.zfunc(N-/)
  ${ZBASEDIR}/.zfunc(N-/)
  ${fpath}
)
