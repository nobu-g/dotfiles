# Git

Git関係の設定ファイル

## 初期設定

以下を実行する:

```
# Account
git config --global user.name "First-name Family-name"
git config --global user.email "username@example.com"

# Editor
git config --global core.editor 'emacs'

# Alias (option)
git config --global alias.bra branch
git config --global alias.cam commit -a -m
git config --global alias.cm commit -m
git config --global alias.co checkout
git config --global alias.cob checkout -b
git config --global alias.com checkout master
git config --global alias.s status
git config --global alias.unstage reset HEAD --
git config --global alias.last log -1 HEAD
git config --global alias.l log --graph --pretty='%C(yellow)%h%Creset %C(cyan bold)%d%Creset %s %Cgreen[%cd] %C(bold blue)<%an> %Creset' --decorate --date=iso

# Color
git config --global color.ui auto

# Global gitignore
ln -s <dotfiles>/.git.d/.gitignore_global ~/.config/git/ignore
```
