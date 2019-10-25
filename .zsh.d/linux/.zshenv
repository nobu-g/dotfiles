# GXP3
if [[ -d $HOME/gxp3 ]]; then
   PATH=$HOME/gxp3:$PATH
fi


# baracuda, moss, saffron 設定
if [[ $(uname -n) =~ "^baracuda" ]] || [[ $(uname -n) =~ "^moss" ]] || [[ $(uname -n) = "saffron" ]]; then
    export CUDA_HOME=/usr/local/cuda
    export CUDA_PATH=/usr/local/cuda
    export PATH=/usr/local/bin:$CUDA_HOME/bin:$PATH
    export LD_LIBRARY_PATH=/usr/lib64:/usr/lib/x86_64-linux-gnu:/usr/local/lib64:$CUDA_HOME/lib64:$LD_LIBRARY_PATH
    export CUDA_DEVICE_ORDER=PCI_BUS_ID
fi

# Boost
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/usr/lib/x86_64-linux-gnu


PATH=/share/usr-$(uname -m)/bin:$PATH
if [[ -f /mnt/orange/ubrew/brew.zsh ]] then
    source /mnt/orange/ubrew/brew.zsh
fi
