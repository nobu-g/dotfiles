# ALIAS
if [ -f ${HOME}/dotfiles/.zsh.d/.zaliases ]; then
    source ${HOME}/dotfiles/.zsh.d/.zaliases
fi

# COLOR
export LS_COLORS=':no=00:fi=00:di=36:ln=35:pi=33:so=32:bd=34;46:cd=34;43:ex=31:'
export LSCOLORS=gxfxcxdxbxegexabagacad  # GNU系の LS_COLORS に相当
export TERM='xterm-256color'

# HOOK
autoload -Uz add-zsh-hook

# PROMPT
setopt prompt_subst  # PROMPT変数内で変数参照する
setopt prompt_percent
setopt transient_rprompt  # コマンド実行後に右プロンプトを消す(?)
## DISPLAY SETTING
autoload -Uz colors && colors

## DISPLAY
# case ${UID} in
# 0)
#     PROMPT="%{${fg[cyan]}%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') %B%{${fg[red]}%}%/#%{${reset_color}%}%b "
#     PROMPT2="%B%{${fg[yellow]}%}%_#%{${reset_color}%}%b "
#     SPROMPT="%B%{${fg[yellow]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
#     [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
#         PROMPT="%{${fg[cyan]%}${HOST%%.*} ${PROMPT}"
#     ;;
# *)
#     PROMPT="%{${fg[yellow]}%}%/%%%{${reset_color}%} "
#     PROMPT2="%{${fg[yellow]}%}%_%%%{${reset_color}%} "
#     SPROMPT="%{${fg[yellow]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
#     [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
#         PROMPT="%{${fg[cyan]}%}${HOST%%.*} ${PROMPT}"
#     ;;
# esac

PROMPT="%F{green}local%f%F{yellow}(%~)%f
$ "

WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

# COMMAND HISTORY
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=$HISTSIZE
setopt hist_ignore_dups     # 直前と同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups # 過去に同じ履歴が存在する場合、古い履歴を削除する
setopt hist_ignore_space    # コマンドの先頭がスペースの場合履歴に追加しない
setopt inc_append_history   # append command to list immediately
setopt share_history        # 同時に起動した zsh の間でヒストリを共有する
setopt hist_reduce_blanks   # ヒストリに保存するときに余分なスペースを削除する
setopt hist_expand          # 補完時にヒストリを自動的に展開
## Do not add in root
if [[ $UID == 0 ]]; then
    unset HISTFILE
    export SAVEHIST=0
fi


# KEY SETTING FOR COMMAND HISTORY
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[p" history-beginning-search-backward-end
bindkey "^[n" history-beginning-search-forward-end

# EMACS-LIKE KEYBINDINGS
bindkey -d # reset
bindkey -e
bindkey "^[f" emacs-forward-word
bindkey "^[b" emacs-backward-word

# COMPLETION
## initialize
autoload -Uz compinit && compinit -C

## Fuzzy match
### https://gihyo.jp/dev/serial/01/zsh-book/0005 を参考
### 補完候補がなければより曖昧に候補を探す。
### m:{a-z}={A-Z}: 小文字を大文字に変えたものでも補完する。
### r:|[._-]=*: 「.」「_」「-」の前にワイルドカード「*」があるものとして補完する。
### l:|=*: 入力文字の前にワイルドカード「*」があるものとして補完する。
### r:|?=**: 各入力文字の前後に「*」があるものとして補完する(?)。
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}' '+r:|[-_.]=**' '+l:|=*' '+r:|?=**'
#zstyle ':completion:*' completer _oldlist _complete _match _history _ignored _approximate _prefix
zstyle ':completion:*' completer _oldlist _complete _match _ignored _approximate _prefix

# Format
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

### color
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

## misc.
### Show selected candidate
zstyle ':completion:*:default' menu select=2
### Show man candidates with section
zstyle ':completion:*:manuals' separate-sections true
### Directory candidates order
zstyle ':completion:*:cd:*' tag-order local-directories path-directories
### use cache
zstyle ':completion:*' use-cache yes
### use sudo path
zstyle ':completion:sudo:*' environ PATH="$SUDO_PATH:$PATH"
setopt complete_in_word  # complete at cursor point
setopt glob_complete
setopt hist_expand  # 補完時にヒストリを自動的に展開
setopt no_beep
setopt numeric_glob_sort


# OTHER OPTIONS
setopt auto_cd               # ディレクトリ名だけでcdする
setopt auto_param_slash      # ディレクトリ名を補完すると末尾に/を追加する
setopt auto_pushd            # cd したら自動的にスタックに入れる
setopt auto_remove_slash     # 補完による/の追加を、続く文字により削除する
setopt globdots              # ドットファイルを*で選択する
setopt extended_glob         # 高機能なワイルドカード展開を使用する
setopt function_argzero      # シェル関数やスクリプトの source 実行時に、$0 を一時的にその関数スクリプト名にセットする
setopt ignore_eof            # C-d でzshを終了しない
setopt list_types            # 補完候補一覧でファイルの種別を識別マーク表示(訳注: ls -F の記号)
setopt pushd_ignore_dups     # 重複したディレクトリを追加しない
setopt pushd_silent          # pushd と popdでスタック表示を抑制
setopt pushd_to_home         # 引数なしの pushd は pushd $HOME になる
setopt sun_keyboard_hack     # 行の末尾がバッククォートでも無視する
setopt print_eight_bit       # 日本語ファイル名を表示可能にする
setopt complete_in_word      # 語の途中でもカーソル位置で補完
setopt no_nomatch
setopt share_history         # 同時に起動した zsh の間でヒストリを共有する
setopt extended_history      # 履歴ファイルにzsh の開始・終了時刻を記録する
setopt nohup
# setopt correct
setopt list_packed

unsetopt promptcr


# cdの後にlsを実行
function chpwd_ls() {
    ls
}
add-zsh-hook chpwd chpwd_ls


# mkdirとcdを同時実行
function mkcd() {
    if [[ -d $1 ]]; then
        echi "$1 already exists!"
        cd $1
    else
        mkdir -p $1 && cd $1
    fi
}


# peco
function peco-select-history() {
  BUFFER=$(\history -n -r 1 | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
#  zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

## search a destination from cdr list
function peco-get-destination-from-cdr() {
  cdr -l | \
  sed -e 's/^[[:digit:]]*[[:blank:]]*//' | \
  peco --query "$LBUFFER"
}

## search a destination from cdr list and cd the destination
function peco-cdr() {
  local destination="$(peco-get-destination-from-cdr)"
  if [ -n "$destination" ]; then
    BUFFER="cd $destination"
    zle accept-line
  else
    zle reset-prompt
  fi
}
zle -N peco-cdr
bindkey '^x' peco-cdr

# cdr設定(pecoの'^x'に必要)
autoload -Uz chpwd_recent_dirs cdr
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 10000
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert both


# カレントディレクトリを変更すると自動的に仮想環境に入るようにする
if [ -f ~/utils/virtualenv-auto-activate.sh ]; then
    source ~/utils/virtualenv-auto-activate.sh
fi
unset VIRTUAL_ENV  # zsh起動時にvirtualenvから抜けるので


# shell integration 設定
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


# pipenv設定
export PIPENV_VENV_IN_PROJECT=true  # pipenv で仮想環境をプロジェクト直下に作るように


# LOAD SETTING FILES
source ${ZSHHOME}/.zshrc
