# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# ALIAS
if [[ -f $HOME/dotfiles/.zsh.d/.zaliases ]]; then
    source $HOME/dotfiles/.zsh.d/.zaliases
fi

# HOOK
autoload -Uz add-zsh-hook

# RESET KEY BINDINGS
bindkey -d

# COLOR
# export LS_COLORS=':no=00:fi=00:di=36:ln=35:pi=33:so=32:bd=34;46:cd=34;43:ex=31:'
# export LSCOLORS=gxfxcxdxbxegexabagacad  # GNU系の LS_COLORS に相当
export TERM='xterm-256color'

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
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

# EMACS-LIKE KEYBINDINGS
bindkey -e
# bindkey "^[[1;5D" backward-word
# bindkey "^[[1;5C" forward-word

# COMPLETION
## initialize
# autoload -Uz compinit && compinit -C

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
# zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

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


source "$HOME/.zplugin/bin/zplugin.zsh"
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin

# debug mode
# typeset -g ZPLG_MOD_DEBUG=1


zplugin ice atclone"dircolors -b LS_COLORS > clrs.zsh" atpull'%atclone' pick"clrs.zsh" nocompile'!'
zplugin light trapd00r/LS_COLORS
zplugin ice wait"0c" lucid reset \
    atclone"dircolors -b <(sed '/^LINK/c\LINK 35' LS_COLORS) > clrs.zsh" \
    atpull'%atclone' pick"clrs.zsh" nocompile'!' \
    atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
zplugin light trapd00r/LS_COLORS

zplugin ice wait lucid
zplugin light zsh-users/zsh-history-substring-search
# zplugin load zdharma/history-search-multi-word


## zsh-autosuggestions
zplugin ice wait lucid atload"_zsh_autosuggest_start"
zplugin light zsh-users/zsh-autosuggestions
# Widgets that accept the entire suggestion
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(
    end-of-line
    vi-end-of-line
    vi-add-eol
)
# Widgets that accept the suggestion as far as the cursor moves
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=(
    forward-char
    forward-word
    emacs-forward-word
    vi-forward-char
    vi-forward-word
    vi-forward-word-end
    vi-forward-blank-word
    vi-forward-blank-word-end
    vi-find-next-char
    vi-find-next-char-skip
)
# Widgets that accept the entire suggestion and execute it
ZSH_AUTOSUGGEST_EXECUTE_WIDGETS=(
)


## fast-syntax-highlighting
# zplugin ice wait lucid atinit"ZPLGM[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay -q"
zplugin light zdharma/fast-syntax-highlighting


## completion
zplugin ice wait lucid blockf atpull'zplugin creinstall -q .'
zplugin light zsh-users/zsh-completions


## clipcopy and clippaste function
zplugin snippet 'OMZ::lib/clipboard.zsh'

# ogham/exa, replacement for ls
zplugin ice wait lucid from"gh-r" as"program" mv"exa* -> exa"
zplugin light ogham/exa

# direnv
zplugin ice as"program" make'!' atclone'./direnv hook zsh > zhook.zsh' \
    atpull'%atclone' pick"direnv" src"zhook.zsh"
zplugin light direnv/direnv
p=$PWD
while  [[ $p != '/' ]]
do
    if [[ -f $p/.envrc ]]; then
        direnv allow
        break
    fi
    p=$(dirname $p)
done

# pyenv
# zplugin ice wait'1' lucid atclone'./libexec/pyenv init - > zpyenv.zsh' atpull"%atclone" \
#     as'command' pick'bin/pyenv' src"zpyenv.zsh" nocompile'!'
# zplugin light pyenv/pyenv

## peco
zplugin ice from"gh-r" as"program" mv"peco* -> peco" pick"peco/peco"
zplugin light peco/peco

# sharkdp/fd, replacement for find
zplugin ice as"command" from"gh-r" mv"fd* -> fd" pick"fd/fd"
zplugin light sharkdp/fd

# sharkdp/bat, replacement for cat
zplugin ice as"command" from"gh-r" mv"bat* -> bat" pick"bat/bat"
zplugin light sharkdp/bat

## comand line translation
# zplugin ice as"program" atclone"rm -f src/auto/config.cache" atpull"%atclone" \
#     make"TARGET=zsh -v" make"install PREFIX=$ZPFX -v" pick"$ZPFX/bin/trans"
zplugin light soimort/translate-shell

## 一旦コメントアウト(あとでいいのを選ぶ)
# prompt theme (1)
# zplugin ice wait'!' lucid atload'source ~/.p10k.zsh; _p9k_precmd' nocd
# zplugin light romkatv/powerlevel10k
# prompt theme (2)
# zplugin ice pick"async.zsh" src"pure.zsh"
# zplugin light sindresorhus/pure
# zplugin snippet OMZ::themes/dstufft.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


## auto ls after changing directory
chpwd_ls() { ls }
add-zsh-hook chpwd chpwd_ls


# mkdir and cd
mkcd() {
    if [[ -d $1 ]]; then
        echi "$1 already exists!"
        cd $1
    else
        mkdir -p $1 && cd $1
    fi
}


# grep を除いて任意のプロセスを表示
pss () {
    ps aux | grep -E "PID|$1" | grep -v grep
}


# LESS man page colors (makes Man pages more readable).
man() {
    env \
        LESS_TERMCAP_mb=$'\E[01;31m' \
        LESS_TERMCAP_md=$'\E[01;31m' \
        LESS_TERMCAP_me=$'\E[0m' \
        LESS_TERMCAP_se=$'\E[0m' \
        LESS_TERMCAP_so=$'\E[00;44;37m' \
        LESS_TERMCAP_ue=$'\E[0m' \
        LESS_TERMCAP_us=$'\E[01;32m' \
        man "$@"
}


## peco
peco-select-history() {
  BUFFER=$(\history -n -r 1 | peco --query "$LBUFFER" --prompt "[hist]" --print-query | tail -n 1)
  CURSOR=$#BUFFER
#  zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

## search a destination from cdr list and cd the destination
peco-cdr() {
  local dest=$(cdr -l | sed -Ee 's/^[0-9]+\s+//' | peco --query "$LBUFFER" --prompt "[dest]")
  if [[ -n "$dest" ]]; then
    BUFFER="cd $dest"
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
zstyle ':chpwd:*' recent-dirs-max 2000
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert both

# peco find file (https://k0kubun.hatenablog.com/entry/2014/07/06/033336)
peco-find-file() {
    if git rev-parse 2> /dev/null; then
        source_files=$(git ls-files)
    else
        source_files=$(find . -type f)
    fi
    selected_files=$(echo $source_files | peco --prompt "[find file]" | tr '\n', ' ')

    BUFFER=${BUFFER}${selected_files}
    CURSOR=$#BUFFER
    zle redisplay
}
zle -N peco-find-file
bindkey '^_' peco-find-file  # works by ^/

# shell integration 設定
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# pyenv
# if (type pyenv &> /dev/null); then
#     eval "$(pyenv init -)"  # 自動補完機能
# fi

# LOAD SETTING FILES
source ${ZSHHOME}/.zshrc

if (which zprof > /dev/null 2>&1) ;then
  zprof
fi
