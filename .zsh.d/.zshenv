# profiling (remove comment out below to profile)
# zmodload zsh/zprof && zprof

# LANG
export LANG=ja_JP.UTF-8
export LANGUAGE=en_US
export LC_CTYPE=${LANG}
export LC_ALL=${LANG}

# PATH(GENERAL)
## zsh の機能で、path (array) は PATH と自動的に連動する
## -U: 重複したパスを登録しない
typeset -U path
path=(
  /usr/local/{bin,sbin}(N-/)
  /usr/{bin,sbin}(N-/)
  /{bin,sbin}(N-/)
  ${path[@]}(N-/)
)

# PATH FOR MAN(MANUAL)
typeset -U manpath
manpath=(
  /usr/local/share/man(N-/)
  /usr/share/man(N-/)
)


# PATH(SUDO)
## -x: export SUDO_PATHも一緒に行う。
## -T: SUDO_PATHとsudo_pathを連動する。
typeset -xT SUDO_PATH sudo_path
typeset -U sudo_path
sudo_path=({,/usr/pkg,/usr/local,/usr}/sbin(N-/))

if [[ $(id -u) -eq 0 ]]; then  # root user
  path=(${sudo_path} ${path})
fi


# Golang
if [[ -d ${HOME}/.go ]]; then
  export GOPATH=${HOME}/.go
  path=(${GOPATH}/bin(N-/) ${path})
fi

# Rust
if [[ -d ${HOME}/.cargo ]]; then
  path=(${HOME}/.cargo/bin(N-/) ${path})
fi


# Poetry
path=(${HOME}/.poetry/bin(N-/) ${path})


# doom-emacs
path=(${HOME}/.emacs.d/bin(N-/) ${path})


# Homebrew/Linuxbrew で prefix のパスが違う。
# $(brew --prefix) は時間がかかる処理であるため、ここで判定して HOMEBREW_PREFIX に格納する。
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


if [[ -n ${HOMEBREW_PREFIX} ]]; then
  # Homebrew の PATH の解決をここで行う。
  export HOMEBREW_PREFIX
  export HOMEBREW_CELLAR="${HOMEBREW_PREFIX}/Cellar"
  export HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}/Homebrew"
  export PATH="${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin${PATH+:$PATH}"
  export MANPATH="${HOMEBREW_PREFIX}/share/man${MANPATH+:$MANPATH}:"
  export INFOPATH="${HOMEBREW_PREFIX}/share/info${INFOPATH+:$INFOPATH}"
fi


# my scripts
path=(${HOME}/scripts(N-/) ${path})
