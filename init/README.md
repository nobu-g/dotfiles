# Setup Scripts

## Additional setup

sudoでTouchIDが使えるようにする
`/etc/pam.d/sudo` の最初に以下の１行を追加

```text
auth       sufficient     pam_tid.so
```
