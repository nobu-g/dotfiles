# Setup Scripts

## Additional setup (Mac)

### Enable TouchID when running `sudo`

1. Add write permission to `/etc/pam.d/sudo`

    ```shell
    sudo chmod +w /etc/pam.d/sudo
    ```

1. Add the following line to the beginning of `/etc/pam.d/sudo`.

    ```text
    auth       sufficient     pam_tid.so
    ```

1. Restore the permission.

    ```shell
    sudo chmod -w /etc/pam.d/sudo
    ```

### Synchronize configuration files that are not managed by dotfiles

1. Login to Dropbox

1. `mackup restore`
