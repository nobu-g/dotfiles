# baracuda, moss, saffron 設定
if [[ $(uname -n) =~ "^baracuda" ]] || [[ $(uname -n) =~ "^moss" ]] || [[ $(uname -n) = "saffron" ]]; then
  export CUDA_HOME=/usr/local/cuda
  export CUDA_PATH=/usr/local/cuda
  export PATH=/usr/local/bin:$CUDA_HOME/bin:$PATH
  export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$CUDA_HOME/lib64:$LD_LIBRARY_PATH
  export CUDA_DEVICE_ORDER=PCI_BUS_ID
fi

# Boost
typeset -xT LD_LIBRARY_PATH ld_library_path  # LD_LIBRARY_PATH を unset すると色々なプログラムの実行が少し速くなる
typeset -U ld_library_path
ld_library_path=(
  $HOME/usr/lib/x86_64-linux-gnu(N-/)
  $HOME/usr/lib(N-/)
  $ld_library_path
)

# XDG Base Directory Specification (Ubuntu specific)
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_DIRS=$HOMEBREW_PREFIX/share:/usr/local/share:/usr/share
export XDG_CONFIG_DIRS=/etc/xdg
export XDG_CACHE_HOME=$HOME/.cache
# export XDG_RUNTIME_DIR=

# pyenv
export PYENV_ROOT=$HOME/.pyenv

path=(
  ${HOME}/gxp3(N-/)  # GXP3
  ${PYENV_ROOT}/bin(N-/)  # pyenv
  /share/usr-$(uname -m)/bin(N-/)
  ${path}
)

# # ubrew
# if [[ -e /mnt/orange/ubrew/data ]]; then
#   export PATH="/mnt/orange/ubrew/data/bin:$PATH"
#   export MANPATH="/mnt/orange/ubrew/data/share/man:$MANPATH"
#   export INFOPATH="/mnt/orange/ubrew/data/share/info:$INFOPATH"
# fi


# Skip the not really helping Ubuntu global compinit
# see /etc/zsh/zshrc
skip_global_compinit=1
