# Setup Scripts

## Additional setup (Mac)

### Enable TouchID when running `sudo`

1. Copy the template file to `/etc/pam.d/sudo_local`.

    ```shell
    sudo cp /etc/pam.d/sudo_local.template /etc/pam.d/sudo_local
    ```

1. Edit `/etc/pam.d/sudo_local` to uncomment the following line:

    ```text
    auth       sufficient     pam_tid.so
    ```

### Synchronize configuration files that are not managed by dotfiles

1. Login to Dropbox

1. `mackup restore`
