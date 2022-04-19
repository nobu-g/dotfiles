# Git

Git settings

## Init

Run following commands:

```shell
git config --global user.name "First-name Family-name"
git config --global user.email "username@example.com"
```

If you edit `~/.config/git/config` and add `# gitignore` to the end of user.name or user.email field, git ignores these lines.

```text
[user]
    name = First-name Family-name  # gitignore
    email = username@example.com  # gitignore
```
