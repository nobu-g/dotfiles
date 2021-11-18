# profiling (set ZPROF environment variable to profile)
if (( ${+ZPROF} )); then
  zmodload zsh/zprof && zprof
fi

# LANG
export LANG=ja_JP.UTF-8
export LANGUAGE=en_US

# PATH Settings
## Zsh synchronizes path, manpath, and fpath with PATH, MANPATH, and FPATH respectively
## -U: keep array values unique
## -x: export parameter
## -T: tie scalar to array
## Exclude the paths under $HOME since they will be added later.
## (N-/): Glob Qualifiers
### N: use NULL_GLOB
### -: follow symlinks toggle
### /: directories
typeset -U path manpath fpath
typeset -xUT INFOPATH infopath
typeset -xUT SUDO_PATH sudo_path
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


# realpath or readlink -f
if (( $+commands[realpath] )); then
  RESOLVE="realpath"
elif (( $+commands[greadlink] )); then
  RESOLVE=("greadlink" "-f")
else
  RESOLVE=("readlink" "-f")
fi

# Homebrew/Linuxbrew で prefix のパスが違う
# $(brew --prefix) は時間がかかる処理のため、ここで判定して HOMEBREW_PREFIX に格納する
if [[ -d ${HOME}/.linuxbrew ]]; then
  HOMEBREW_PREFIX="$(${RESOLVE} ${HOME}/.linuxbrew)"
elif [[ -d /home/.linuxbrew ]]; then
  HOMEBREW_PREFIX="$(${RESOLVE} /home/.linuxbrew)"
elif [[ -x /usr/local/bin/brew ]]; then
  HOMEBREW_PREFIX="/usr/local"
elif [[ -x /opt/homebrew/bin/brew ]]; then
  HOMEBREW_PREFIX="/opt/homebrew"
fi

# Python
export PYTHONUSERBASE="$HOME/.local"

# PIPENV
if [[ -d /mnt/berry_f/home ]]; then
  export WORKON_HOME="/mnt/berry_f/home/${USER}/.virtualenvs"  # use cached directory for virtualenv
else
  export PIPENV_VENV_IN_PROJECT=true  # pipenv で仮想環境をプロジェクト直下に作るように
fi

# PYTEST
export PYTEST_ADDOPTS="-v -s --ff"

# zmv
autoload -Uz zmv

ZBASEDIR="$(dirname "$(${RESOLVE} "${(%):-%N}")")"
case "${OSTYPE}" in
linux*|cygwin*)
  ZENVDIR="${ZBASEDIR}/linux"
  ;;
freebsd*|darwin*)
  ZENVDIR="${ZBASEDIR}/macos"
  ;;
esac

# load environment specific configurations
source "${ZENVDIR}/.zshenv"

if [[ -n ${HOMEBREW_PREFIX} ]]; then
  export HOMEBREW_PREFIX
  export HOMEBREW_CELLAR="${HOMEBREW_PREFIX}/Cellar"
  export HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}/Homebrew"
  path=(${HOMEBREW_PREFIX}/{bin,sbin}(N-/) ${path})
  manpath=(${HOMEBREW_PREFIX}/share/man(N-/) ${manpath})
  infopath=(${HOMEBREW_PREFIX}/share/info(N-/) ${infopath})
  fpath=(${HOMEBREW_PREFIX}/share/zsh/{functions,site-functions}(N-/) ${fpath})
fi

# Ruby
if [[ -n ${HOMEBREW_PREFIX} ]]; then
  path=(${HOMEBREW_PREFIX}/opt/ruby/bin(N-/) ${path})
fi

# Golang
if [[ -d ${HOME}/.go ]]; then
  export GOPATH="${HOME}/.go"
  path=(${GOPATH}/bin(N-/) ${path})
fi

path=(
  ${HOME}/.cargo/bin(N-/)  # Rust
  ${HOME}/.poetry/bin(N-/)  # Poetry
  ${HOME}/.emacs.d/bin(N-/)  # doom-emacs
  ${HOME}/.gem/ruby/3.0.0/bin(N-/)  # gem
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
