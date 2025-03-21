export XDG_RUNTIME_DIR="/run/user/$(id -u)"  # https://serverfault.com/a/887298

# settings for hosts with CUDA installed
if [[ -d /usr/local/cuda ]]; then
  export CUDA_HOME="/usr/local/cuda"
  export CUDA_PATH="${CUDA_HOME}"
  export PATH="${CUDA_HOME}/bin:${PATH}"
  export LD_LIBRARY_PATH="${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}"
  export CUDA_DEVICE_ORDER="PCI_BUS_ID"
fi

# LD_LIBRARY_PATH を unset すると色々なプログラムの実行が少し速くなる (/home を読みにいかなくなるため)
# typeset -xT LD_LIBRARY_PATH ld_library_path
# typeset -U ld_library_path
# ld_library_path=(
#   $HOME/usr/lib/x86_64-linux-gnu(N-/)
#   $HOME/usr/lib(N-/)
#   $ld_library_path
# )

# Shared Programs
if [[ -e /home/linuxbrew/.linuxbrew ]]; then
  prefix="/home/linuxbrew/.linuxbrew"
  path=(${prefix}/{bin,sbin}(N-/) ${path})
  manpath=(${prefix}/share/man(N-/) ${manpath})
  infopath=(${prefix}/share/info(N-/) ${infopath})
  fpath=(${prefix}/share/zsh/site-functions(N-/) ${fpath})
fi
if [[ -e /home/linuxbrew/.local ]]; then
  prefix="/home/linuxbrew/.local"
  path=(${prefix}/{bin,sbin}(N-/) ${path})
  manpath=(${prefix}/share/man(N-/) ${manpath})
  infopath=(${prefix}/share/info(N-/) ${infopath})
  fpath=(${prefix}/share/zsh/{functions,site-functions}(N-/) ${fpath})
fi

# GXP3
path=(${HOME}/gxp3(N-/) ${path})

# Skip the not really helping Ubuntu global compinit
# see /etc/zsh/zshrc
skip_global_compinit=1
