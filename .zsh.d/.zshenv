# profiling (set ZPROF environment variable to profile)
if (( ${+ZPROF} )); then
  zmodload zsh/zprof && zprof
fi

# LANG
export LANG=ja_JP.UTF-8
export LANGUAGE=en_US

# PATH の設定
## zsh の機能で、path,manpath,fpath は PATH,MANPATH,FPATH と自動的に連動する
## -U: 重複したパスを登録しない
## HOME 以下の path は後で設定するので除外
# PATH
typeset -U path
path=(
  /usr/local/{bin,sbin}(N-/)
  /usr/{bin,sbin}(N-/)
  /{bin,sbin}(N-/)
  ${path:#${HOME}/*}(N-/)
)
# MANPATH
typeset -U manpath
manpath=(
  /usr/local/share/man(N-/)
  /usr/share/man(N-/)
  ${manpath:#${HOME}/*}(N-/)
)
# FPATH
typeset -U fpath
fpath=(
  /usr/local/share/zsh/site-functions(N-/)
  /usr/share/zsh/site-functions(N-/)
  ${fpath:#${HOME}/*}(N-/)
)

# PATH (SUDO)
## -x: export SUDO_PATHも一緒に行う。
## -T: SUDO_PATHとsudo_pathを連動する。
typeset -xT SUDO_PATH sudo_path
typeset -U sudo_path
sudo_path=({,/usr/pkg,/usr/local,/usr}/sbin(N-/))

if [[ $(id -u) -eq 0 ]]; then  # root user
  path=(${sudo_path} ${path})
fi


# Homebrew/Linuxbrew で prefix のパスが違う。
# $(brew --prefix) は時間がかかる処理のため、ここで判定して HOMEBREW_PREFIX に格納する。
if [[ -d ${HOME}/.linuxbrew ]]; then
  HOMEBREW_PREFIX=$(readlink -f ${HOME}/.linuxbrew)
elif [[ -d /home/.linuxbrew ]]; then
  HOMEBREW_PREFIX=$(readlink -f /home/.linuxbrew)
elif [[ -x /usr/local/bin/brew ]]; then
  HOMEBREW_PREFIX="/usr/local"
fi


## lv setting
export LV="-c -l"

## less setting (https://qiita.com/delphinus/items/b04752bb5b64e6cc4ea9)
export LESS="-i -M -R -x4"
# LESS="$LESS -X -F"
export LESSCHARSET='utf-8'
if [[ -e ${HOMEBREW_PREFIX}/bin/src-hilite-lesspipe.sh ]]; then
  export LESSOPEN="| ${HOMEBREW_PREFIX}/bin/src-hilite-lesspipe.sh %s"
fi

# PAGER
export PAGER="less"


# EDITOR
export EDITOR=emacsclient
export EMACS_SERVER_SOCKET=${TMPDIR:-/tmp}/emacs$(id -u)/server

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


case "${OSTYPE}" in
linux*|cygwin*)
  ZSHHOME="${HOME}/dotfiles/.zsh.d/linux"
  ;;
freebsd*|darwin*)
  ZSHHOME="${HOME}/dotfiles/.zsh.d/osx"
  ;;
esac

# load environment specific configurations
source ${ZSHHOME}/.zshenv


if [[ -n ${HOMEBREW_PREFIX} ]]; then
  # Homebrew の PATH の解決をここで行う。
  export HOMEBREW_PREFIX
  export HOMEBREW_CELLAR="${HOMEBREW_PREFIX}/Cellar"
  export HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}/Homebrew"
  export INFOPATH="${HOMEBREW_PREFIX}/share/info${INFOPATH+:$INFOPATH}"
  path=(${HOMEBREW_PREFIX}/{bin,sbin}(N-/) ${path})
  manpath=(${HOMEBREW_PREFIX}/share/man(N-/) ${manpath})
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
  ${HOME}/.local/bin(N-/)
  ${HOME}/local/bin(N-/)
  ${HOME}/usr/bin(N-/)
  ${path}
)
manpath=(
  ${HOME}/.local/share/man(N-/)
  ${HOME}/local/share/man(N-/)
  ${HOME}/usr/share/man(N-/)
  ${manpath}
)
fpath=(
  ${HOME}/.local/share/zsh/site-functions(N-/)
  ${HOME}/local/share/zsh/site-functions(N-/)
  ${HOME}/usr/share/zsh/site-functions(N-/)
  ${fpath}
)


# my scripts and functions
path=(${HOME}/scripts(N-/) ${path})
fpath=(${HOME}/dotfiles/.zsh.d/functions(N-/) ${fpath})
