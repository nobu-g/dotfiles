FROM debian:latest

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends sudo
# add sudo user
RUN groupadd -g 1000 wheel && \
    useradd -g wheel -G sudo -m -s /bin/bash user && \
    echo 'user:hogehoge' | chpasswd
RUN echo 'Defaults visiblepw' >> /etc/sudoers && \
    echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
# install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    make \
    zsh \
    gcc \
    build-essential \
    procps \
    ca-certificates \
    curl \
    file \
    git \
    zlib1g-dev \
    python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# RUN echo y | sh -c "$(curl -fsSL https://raw.githubusercontent.com/nobu-g/dotfiles/main/install.sh)"

CMD [ "/bin/zsh" ]
