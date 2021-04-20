# profiling (set ZPROF environment variable to profile)
if (( ${+ZPROF} )); then
  zmodload zsh/zprof && zprof
fi

# LANG
export LANG=ja_JP.UTF-8
export LANGUAGE=en_US

# PATH Settings
## zsh の機能で、path,manpath,fpath は PATH,MANPATH,FPATH と自動的に連動する
## -U: 重複したパスを登録しない
## -x: export も一緒に行う
## -T: SUDO_PATHとsudo_pathを連動する
## HOME 以下の path は後で設定するので除外
typeset -U path manpath fpath
typeset -xUT INFOPATH infopath
typeset -xUT SUDO_PATH sudo_path
# PATH
path=(
  /usr/local/{bin,sbin}(N-/)
  /usr/{bin,sbin}(N-/)
  /{bin,sbin}(N-/)
  ${path:#${HOME}/*}(N-/)
)
# MANPATH
manpath=(
  /usr/local/share/man(N-/)
  /usr/share/man(N-/)
  ${manpath:#${HOME}/*}(N-/)
)
# INFOPATH
infopath=(
  /usr/local/share/info(N-/)
  /usr/share/info(N-/)
  ${infopath:#${HOME}/*}(N-/)
)
# FPATH
fpath=(
  /usr/local/share/zsh/site-functions(N-/)
  /usr/share/zsh/site-functions(N-/)
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
  HOMEBREW_PREFIX=$(${RESOLVE} ${HOME}/.linuxbrew)
elif [[ -d /home/.linuxbrew ]]; then
  HOMEBREW_PREFIX=$(${RESOLVE} /home/.linuxbrew)
elif [[ -x /usr/local/bin/brew ]]; then
  HOMEBREW_PREFIX="/usr/local"
fi

# Python
export PYTHONUSERBASE="$HOME/.local"

# PIPENV
if [[ -d /mnt/berry_f/home ]]; then
  export WORKON_HOME=/mnt/berry_f/home/${USER}/.virtualenvs  # use cached directory for virtualenv
else
  export PIPENV_VENV_IN_PROJECT=true  # pipenv で仮想環境をプロジェクト直下に作るように
fi

# PYTEST
export PYTEST_ADDOPTS='-v -s --ff'

# zmv
autoload -Uz zmv

ZBASEDIR="$(dirname "$(${RESOLVE} "${(%):-%N}")")"
case "${OSTYPE}" in
linux*|cygwin*)
  ZSHHOME="$ZBASEDIR/linux"
  ;;
freebsd*|darwin*)
  ZSHHOME="$ZBASEDIR/macos"
  ;;
esac

# load environment specific configurations
source ${ZSHHOME}/.zshenv


if [[ -n ${HOMEBREW_PREFIX} ]]; then
  export HOMEBREW_PREFIX
  export HOMEBREW_CELLAR="${HOMEBREW_PREFIX}/Cellar"
  export HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}/Homebrew"
  path=(${HOMEBREW_PREFIX}/{bin,sbin}(N-/) ${path})
  manpath=(${HOMEBREW_PREFIX}/share/man(N-/) ${manpath})
  infopath=(${HOMEBREW_PREFIX}/share/info(N-/) ${infopath})
  fpath=(${HOMEBREW_PREFIX}/share/zsh/site-functions(N-/) ${fpath})
fi


# Golang
if [[ -d ${HOME}/.go ]]; then
  export GOPATH=${HOME}/.go
  path=(${GOPATH}/bin(N-/) ${path})
fi

path=(
  ${HOME}/.cargo/bin(N-/)  # Rust
  ${HOME}/.poetry/bin(N-/)  # Poetry
  ${HOME}/.emacs.d/bin(N-/)  # doom-emacs
  ${HOME}/.nodebrew/current/bin(N-/)  # nodebrew
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
  ${HOME}{/.local,/local,/usr}/share/zsh/site-functions(N-/)
  ${fpath}
)


# my scripts and functions
path=(${HOME}/scripts(N-/) ${path})
fpath=(${ZBASEDIR}/functions(N-/) ${fpath})
