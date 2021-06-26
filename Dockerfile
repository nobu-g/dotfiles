FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    make \
    zsh \
    gcc \
    build-essential \
    procps \
    curl \
    file \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# RUN chsh -s /usr/bin/zsh
# RUN git clone https://github.com/nobu-g/dotfiles

# add sudo user
RUN groupadd -g 1000 wheel && \
    useradd -g wheel -G sudo -m -s /bin/bash user && \
    echo 'user:hogehoge' | chpasswd
RUN echo 'Defaults visiblepw' >> /etc/sudoers && \
    echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# RUN echo y | sh -c "$(curl -fsSL https://raw.githubusercontent.com/nobu-g/dotfiles/main/install.sh)"

CMD [ "zsh" ]
