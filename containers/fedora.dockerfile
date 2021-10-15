FROM fedora:latest

RUN dnf update -y && dnf install -y sudo
# add sudo user
RUN useradd -m -s /bin/bash user && \
    echo 'user:hogehoge' | chpasswd && \
    echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
# install dependencies
RUN dnf update -y && dnf install -y \
    make \
    zsh \
    gcc \
    && dnf group install -y 'Development Tools' \
    && dnf install -y procps-ng \
    curl \
    file \
    git \
    libxcrypt-compat \
    && dnf install -y \
    g++ \
    perl-ExtUtils-MakeMaker \
    perl-FindBin \
    glibc-devel \
    python3 \
    && dnf clean all \
    && rm -rf /var/cache/dnf/* /tmp/* /var/tmp/*

CMD [ "/bin/sh" ]
