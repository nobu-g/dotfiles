# Setup Scripts

## Additional setup (Mac)

### sudoでTouchIDが使えるようにする

`/etc/pam.d/sudo` の最初に以下の１行を追加

```text
auth       sufficient     pam_tid.so
```

### dotfiles で管理していない設定ファイルの同期

1. Login to Dropbox
2. `mackup restore`
