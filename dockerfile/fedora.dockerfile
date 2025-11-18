FROM fedora:42

RUN dnf update -y && dnf install -y sudo && dnf clean all
# add sudo user
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN useradd -m -s /bin/bash user && \
    echo 'user:hogehoge' | chpasswd && \
    echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
# install dependencies
RUN dnf update -y && dnf install -y \
    make \
    zsh \
    gcc \
    g++ \
    glibc-devel \
    procps-ng \
    curl \
    file \
    git \
    libxcrypt-compat \
    perl-ExtUtils-MakeMaker \
    perl-FindBin \
    perl-IPC-Cmd \
    perl-Pod-Html \
    python3 \
    && dnf clean all \
    && rm -rf /var/cache/dnf/* /tmp/* /var/tmp/*

CMD [ "/bin/zsh" ]
