# baracuda, moss, saffron 設定
if [[ $(uname -n) =~ "^baracuda" ]] || [[ $(uname -n) =~ "^moss" ]] || [[ $(uname -n) =~ "^saffron" ]]; then
  export CUDA_HOME=/usr/local/cuda
  export CUDA_PATH=/usr/local/cuda
  export PATH=/usr/local/bin:$CUDA_HOME/bin:$PATH
  export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$CUDA_HOME/lib64:$LD_LIBRARY_PATH
  export CUDA_DEVICE_ORDER=PCI_BUS_ID
fi

# Boost
# LD_LIBRARY_PATH を unset すると色々なプログラムの実行が少し速くなる (/home を読みにいかなくなるため)
# typeset -xT LD_LIBRARY_PATH ld_library_path
# typeset -U ld_library_path
# ld_library_path=(
#   $HOME/usr/lib/x86_64-linux-gnu(N-/)
#   $HOME/usr/lib(N-/)
#   $ld_library_path
# )

# XDG Base Directory Specification (Ubuntu specific)
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_DIRS=$HOMEBREW_PREFIX/share:/usr/local/share:/usr/share
export XDG_CONFIG_DIRS=/etc/xdg
export XDG_CACHE_HOME=$HOME/.cache
export XDG_RUNTIME_DIR=/run/user/$(id -u)  # https://serverfault.com/a/887298

if [[ -n ${HOMEBREW_PREFIX} ]]; then
  export HOMEBREW_PREFIX
  export HOMEBREW_CELLAR="${HOMEBREW_PREFIX}/Cellar"
  export HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}/Homebrew"
  path=(${HOMEBREW_PREFIX}/{bin,sbin}(N-/) ${path})
  manpath=(${HOMEBREW_PREFIX}/share/man(N-/) ${manpath})
  infopath=(${HOMEBREW_PREFIX}/share/info(N-/) ${infopath})
  fpath=(${HOMEBREW_PREFIX}/share/zsh/site-functions(N-/) ${fpath})
fi

# Shared Programs
if [[ -e /home/linuxbrew/.linuxbrew ]]; then
  prefix="/home/linuxbrew/.linuxbrew"
  path=(${prefix}/{bin,sbin}(N-/) ${path})
  manpath=(${prefix}/share/man(N-/) ${manpath})
  infopath=(${prefix}/share/info(N-/) ${infopath})
  fpath=(${prefix}/share/zsh/site-functions(N-/) ${fpath})
fi
if [[ -e /home/linuxbrew/usr ]]; then
  prefix="/home/linuxbrew/usr"
  path=(${prefix}/{bin,sbin}(N-/) ${path})
  manpath=(${prefix}/share/man(N-/) ${manpath})
  infopath=(${prefix}/share/info(N-/) ${infopath})
  fpath=(${prefix}/share/zsh/site-functions(N-/) ${fpath})
fi


# pyenv
export PYENV_ROOT=$HOME/.pyenv

path=(
  ${HOME}/gxp3(N-/)  # GXP3
  ${PYENV_ROOT}/bin(N-/)  # pyenv
  ${path}
)

# Skip the not really helping Ubuntu global compinit
# see /etc/zsh/zshrc
skip_global_compinit=1
