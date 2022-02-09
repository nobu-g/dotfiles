# Setup Scripts

## Additional setup (Mac)

### Enable TouchID when running `sudo`

Add the following line to the beginning of `/etc/pam.d/sudo`.

```text
auth       sufficient     pam_tid.so
```

### Synchronize configuration files that are not managed by dotfiles

1. Login to Dropbox
2. `mackup restore`
