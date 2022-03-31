# Setup Scripts

## Additional setup (Mac)

### Enable TouchID when running `sudo`
1. Add write permission to `/etc/pam.d/sudo`
    ```shell
    sudo chmod +w /etc/pam.d/sudo
    ```
2. Add the following line to the beginning of `/etc/pam.d/sudo`.
    ```text
    auth       sufficient     pam_tid.so
    ```
3. Restore the permission.
    ```text
    sudo chmod -w /etc/pam.d/sudo
    ```

### Synchronize configuration files that are not managed by dotfiles

1. Login to Dropbox
2. `mackup restore`
