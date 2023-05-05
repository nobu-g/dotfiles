# Setup procedures for Linux

## Preliminary

1. Login to the host and install dotfiles on home directory.

    ```shell
    SUDO=1 \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/nobu-g/dotfiles/main/install.sh)"
    ```

## Setting up locales

1. Edit `/etc/locale.gen` and comment out the following lines:

    ```text
    en_US.UTF-8 UTF-8
    ja_JP.UTF-8 UTF-8
    ```

1. Run `sudo locale-gen`.

## Setting up Docker and Docker Compose v2

1. Install Docker.

    ```shell
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    ```

1. Enable docker-cli without sudo.

    ```shell
    sudo usermod -aG docker "${USER}"
    ```

1. Install Docker Compose v2.
    Change `v2.3.0` to the latest version referring to [the release page](https://github.com/docker/compose/releases).

    ```shell
    mkdir -p ~/.docker/cli-plugins
    curl -SL https://github.com/docker/compose/releases/download/v2.3.0/docker-compose-linux-$(uname -m) -o ~/.docker/cli-plugins/docker-compose
    chmod a+x ~/.docker/cli-plugins/docker-compose
    ```

## Enabling PyTorch to use GPUs with Python installed via Homebrew

Enable packages installed via Homebrew to search system library paths, in which CUDA libraries are installed.

```shell
echo "/usr/lib/x86_64-linux-gnu" > ${HOMEBREW_PREFIX}/etc/ld.so.conf.d/95-system-glibc.conf
${HOMEBREW_PREFIX}/opt/glibc/sbin/ldconfig
```
