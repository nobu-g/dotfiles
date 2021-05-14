FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    git \
    make \
    zsh \
    procps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN chsh -s /usr/bin/zsh
# RUN git clone https://github.com/nobu-g/dotfiles
RUN echo y | sh -c "$(curl -fsSL https://raw.github.com/nobu-g/dotfiles/main/install.sh)"

CMD [ "zsh" ]
