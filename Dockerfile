FROM ubuntu

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo y | sh -c "$(curl -fsSL https://raw.github.com/nobu-g/dotfiles/master/install.sh)"
CMD [ "zsh" ]
