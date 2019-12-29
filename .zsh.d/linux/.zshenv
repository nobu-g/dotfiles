# GXP3
path=($HOME/gxp3(N-/) $path)

# baracuda, moss, saffron 設定
if [[ $(uname -n) =~ "^baracuda" ]] || [[ $(uname -n) =~ "^moss" ]] || [[ $(uname -n) = "saffron" ]]; then
    export CUDA_HOME=/usr/local/cuda
    export CUDA_PATH=/usr/local/cuda
    export PATH=/usr/local/bin:$CUDA_HOME/bin:$PATH
    export LD_LIBRARY_PATH=/usr/lib64:/usr/lib/x86_64-linux-gnu:/usr/local/lib64:$CUDA_HOME/lib64:$LD_LIBRARY_PATH
    export CUDA_DEVICE_ORDER=PCI_BUS_ID
fi

# Boost
typeset -xT LD_LIBRARY_PATH ld_library_path  # LD_LIBRARY_PATH を unset すると色々なプログラムの実行が少し速くなる
typeset -U ld_library_path
ld_library_path=(
    $HOME/usr/lib/x86_64-linux-gnu(N-/)
    $ld_library_path
)

path=(/share/usr-$(uname -m)/bin(N-/) $path)
if [[ -f /mnt/orange/ubrew/brew.zsh ]] then
    source /mnt/orange/ubrew/brew.zsh
fi

# pyenv
export PYENV_ROOT=$HOME/.pyenv
path=($PYENV_ROOT/bin(N-/) $path)
