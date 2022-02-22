# COMPLETION
## initialize
# autoload -Uz compinit && compinit -C

## Fuzzy match
### https://gihyo.jp/dev/serial/01/zsh-book/0005 を参考
### 補完候補がなければより曖昧に候補を探す
### m:{a-z}={A-Z}: 小文字を大文字に変えたものでも補完する
### r:|[._-]=*: 「.」「_」「-」の前にワイルドカード「*」があるものとして補完する
### l:|=*: 入力文字の前にワイルドカード「*」があるものとして補完する
### r:|?=**: 各入力文字の前後に「*」があるものとして補完する(?)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}' '+r:|[-_.]=**' '+l:|=*' '+r:|?=**'
#zstyle ':completion:*' completer _oldlist _complete _match _history _ignored _approximate _prefix
zstyle ':completion:*' completer _oldlist _complete _match _ignored _approximate _prefix

## Format
zstyle ':completion:*' verbose yes
zstyle ':completion:*' format '%F{magenta}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:options' description yes
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{yellow}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{magenta}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{blue}-- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- No matches for: %d --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'

## misc.
### Show selected candidate
zstyle ':completion:*:default' menu select=2
### Show man candidates with section
zstyle ':completion:*:manuals' separate-sections true
### Directory candidates order
zstyle ':completion:*:cd:*' tag-order local-directories path-directories
### use cache
zstyle ':completion:*' use-cache yes
zstyle ':completion::complete:*' cache-path "${XDG_CACHE_HOME:-${HOME}/.cache}/zsh/zcompcache"
### use sudo path
zstyle ':completion:sudo:*' environ PATH="$SUDO_PATH:$PATH"
# 今いるディレクトリを補完候補から外す
zstyle ':completion:*' ignore-parents parent pwd ..
