# Setup procedures for Raspberry Pi 4

## Preliminary operations
1. Login to the host via SSH and install dotfiles on home directory.
    ```shell
    SUDO=1 \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/nobu-g/dotfiles/main/install.sh)"
    ```
2. The command above fails to install Homebrew because Homebrew does not support aarch64 architecture.
    In order to make it work, you need to install s specific version of Ruby (2.6.8 on 2022/3) using [the latest rbenv](https://github.com/rbenv/rbenv).
    ```shell
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
    rbenv install 2.6.8
    rbenv global 2.6.8
    ```
    Note that apt package manager also provides a rbenv package. However, it might be too old to install Ruby 2.6.8.
3. And then, run the installation script again.
    ```shell
    eval "$(rbenv init -)"
    cd dotfiles
    make install [FULL_INSTALL=1]
    ```
    Some packages would be installed successfully (some would not).

## More secure SSH connection
1. Install some editor you like (e.g., `sudo apt install emacs`).
2. Edit lines below in `/etc/ssh/sshd_config`.
    ```text
    Port <another-number-than-22>
    PermitRootLogin no
    PubkeyAuthentication yes
    ```

## Setting up locales
1. Edit `/etc/locale.gen` and comment out the following lines:
    ```text
    en_US.UTF-8 UTF-8
    ja_JP.UTF-8 UTF-8
    ```
2. Run `sudo locale-gen`.

## Setting up Docker and Docker Compose v2
1. Install Docker.
    ```shell
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    ```
2. Enable docker-cli without sudo.
    ```shell
    sudo usermod -aG docker "${USER}"
    ```
3. Install Docker Compose v2.
    Change `v2.3.0` to the latest version referring to [the release page](https://github.com/docker/compose/releases).
    ```shell
    mkdir -p ~/.docker/cli-plugins
    curl -SL https://github.com/docker/compose/releases/download/v2.3.0/docker-compose-linux-$(uname -m) -o ~/.docker/cli-plugins/docker-compose
    chmod a+x ~/.docker/cli-plugins/docker-compose
    ```

## Setting up Open VPN server
See https://github.com/kylemanna/docker-openvpn

## ngrok
### Installation
```shell
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm64.tgz
tar xvzf ngrok-stable-linux-arm64.tgz
mv ngrok ~/.local/bin
```
