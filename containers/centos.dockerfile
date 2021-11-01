FROM centos:latest

RUN yum update -y && yum install -y sudo
# add sudo user
RUN useradd -m -s /bin/bash user && \
    echo 'user:hogehoge' | chpasswd && \
    echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
# install dependencies
RUN yum update -y && yum install -y \
    make \
    zsh \
    gcc \
    && yum groupinstall -y 'Development Tools' \
    && yum install -y \
    procps-ng \
    curl \
    file \
    git \
    perl-ExtUtils-MakeMaker \
    glibc-devel \
    python3 \
    && yum clean all \
    && rm -rf /var/cache/yum/* /tmp/* /var/tmp/*

CMD [ "/bin/zsh" ]
