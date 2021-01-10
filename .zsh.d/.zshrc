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

autoload -Uz add-zsh-hook
autoload -Uz colors && colors

# RESET KEY BINDINGS
bindkey -d

# COLOR
# export LS_COLORS=':no=00:fi=00:di=36:ln=35:pi=33:so=32:bd=34;46:cd=34;43:ex=31:'
# export LSCOLORS=gxfxcxdxbxegexabagacad  # GNU系の LS_COLORS に相当
export TERM='xterm-256color'

# PROMPT
## DISPLAY SETTING

WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

# COMMAND HISTORY
HISTFILE=$HOME/.zsh_history
HISTSIZE=200000
SAVEHIST=100000
## Do not add in root
if [[ $UID == 0 ]]; then
  unset HISTFILE
  export SAVEHIST=0
fi

# カレントディレクトリ中にサブディレクトリが無い場合に cd が検索するディレクトリのリスト
cdpath=("$HOME" .. $HOME/*)


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
### 補完候補がなければより曖昧に候補を探す
### m:{a-z}={A-Z}: 小文字を大文字に変えたものでも補完する
### r:|[._-]=*: 「.」「_」「-」の前にワイルドカード「*」があるものとして補完する
### l:|=*: 入力文字の前にワイルドカード「*」があるものとして補完する
### r:|?=**: 各入力文字の前後に「*」があるものとして補完する(?)
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
# 今いるディレクトリを補完候補から外す
zstyle ':completion:*' ignore-parents parent pwd ..


# OTHER OPTIONS
setopt always_last_prompt    # カーソル位置は保持したままファイル名一覧を順次その場で表示
setopt auto_cd               # ディレクトリ名だけでcdする
setopt auto_param_slash      # ディレクトリ名を補完すると末尾に/を追加する
setopt auto_pushd            # cd したら自動的にスタックに入れる
setopt auto_remove_slash     # 補完による/の追加を、続く文字により削除する
setopt brace_ccl             # 範囲指定できるように 例) mkdir {1-3} で フォルダ1,2,3を作れる
setopt combiningchars
setopt complete_in_word      # 語の途中でもカーソル位置で補完
# setopt auto_correct          # 補完時にスペルチェック
# setopt correct               # スペルミスを補完
# setopt correct_all           # コマンドライン全てのスペルチェックをする
setopt extended_glob         # 高機能なワイルドカード展開を使用する
setopt extended_history      # 履歴ファイルに zsh の開始・終了時刻を記録する
setopt function_argzero      # シェル関数やスクリプトの source 実行時に、$0 を一時的にその関数スクリプト名にセットする
setopt glob_complete
setopt globdots              # ドットファイルを*で選択する
setopt hist_expand           # 補完時にヒストリを自動的に展開
setopt hist_ignore_dups      # 直前と同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups  # 過去に同じ履歴が存在する場合、古い履歴を削除する
setopt hist_ignore_space     # スペースで始まるコマンド行はヒストリリストから削除 (→ 先頭にスペースを入れておけば、ヒストリに保存されない)
setopt hist_reduce_blanks    # ヒストリに保存するときに余分なスペースを削除する
setopt ignore_eof            # C-d でzshを終了しない
setopt list_packed           # コンパクトに補完リストを表示
setopt list_types            # 補完候補一覧でファイルの種別を識別マーク表示(訳注: ls -F の記号)
setopt long_list_jobs        # 内部コマンド jobs の出力をデフォルトで jobs -L にする
setopt magic_equal_subst     #  --prefix=~/localというように「=」の後でも「~」や「=コマンド」などのファイル名展開を行う
setopt notify                # バックグラウンドジョブが終了したら(プロンプトの表示を待たずに)すぐに知らせる
setopt no_beep               # コマンド入力エラーでBeepを鳴らさない
setopt no_nomatch            # グロブ展開でnomatchにならないようにする
setopt numeric_glob_sort     # 数字を数値と解釈してソートする
setopt path_dirs             # コマンド名に / が含まれているとき PATH 中のサブディレクトリを探す
setopt pushd_ignore_dups     # 重複したディレクトリを追加しない
setopt pushd_silent          # pushd と popdでスタック表示を抑制
setopt pushd_to_home         # 引数なしの pushd は pushd $HOME になる
unsetopt promptcr            # 改行のない出力をプロンプトで上書きするのを防ぐ
# setopt prompt_subst          # プロンプトを表示する度にPROMPT変数内で変数参照する
# setopt prompt_percent
setopt print_eight_bit       # 日本語ファイル名を表示可能にする
setopt rm_star_wait          # rm * を実行する前に確認
# setopt short_loops           # FOR, REPEAT, SELECT, IF, FUNCTION などで簡略文法が使えるようになる # 使い方よく分からない
setopt sun_keyboard_hack     # 行の末尾がバッククォートでも無視する
setopt nohup                 # シェルが終了しても SIGHUP を job に送らない
setopt transient_rprompt     # コマンド実行後に右プロンプトを消す(?)

# 以下の3つはそれぞれ排他的なオプション
# setopt inc_append_history      # 履歴リストにイベントを登録するのと同時に、履歴ファイルにも書き込みを行う(追加する)。
# setopt inc_append_history_time # コマンド終了時に、履歴ファイルに書き込む
#                                # つまりコマンドの経過時間が正しく記録される
#                                # 逆に言うと `INC_APPEND_HISTORY` × `EXTENDED_HISTORY` の併用では**経過時間が全て0で記録される**
setopt share_history          # 各端末で履歴(ファイル)を共有する = 履歴ファイルに対して参照と書き込みを行う。
                              # 書き込みは 時刻(タイムスタンプ) 付き


# debug mode
# typeset -g ZINIT_MOD_DEBUG=1

# place above compinit
source "$HOME/.zinit/bin/zinit.zsh"
ZINIT[COMPINIT_OPTS]=-C
# if you sourced below compinit following two lines are needed
# autoload -Uz _zinit
# (( ${+_comps} )) && _comps[zinit]=_zinit

#--------------------------------#
# zinit extension
#--------------------------------#
zinit light-mode for \
  @zinit-zsh/z-a-readurl \
  @zinit-zsh/z-a-bin-gem-node
  #@zinit-zsh/z-a-patch-dl \
  #@zinit-zsh/z-a-unscope \
  #@zinit-zsh/z-a-default-ice \
  #@zinit-zsh/z-a-submods
  #@zinit-zsh/z-a-man # -> require gem

zicompdef g='git'
zicompdef gti='git'
zicompdef ll='ls'
zicompdef la='ls'
zicompdef lt='ls'
zicompdef lat='ls'
zicompdef d='docker'

# other themes: dircolors.ansi-dark, dircolors.ansi-light, dircolors.256dark
zinit ice atload'[[ -e $HOME/.zsh-dircolors.config ]] || setupsolarized dircolors.ansi-universal' \
            atload'zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"'
zinit light 'joel-porquet/zsh-dircolors-solarized'

zinit ice wait"1" lucid
zinit light zsh-users/zsh-history-substring-search

# zinit load zdharma/history-search-multi-word

#--------------------------------#
# completion
#--------------------------------#
## zsh-autosuggestions
zinit wait"1" lucid atload"_zsh_autosuggest_start" atinit"zicompinit; zicdreplay -q" \
  light-mode for @zsh-users/zsh-autosuggestions
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
ZSH_AUTOSUGGEST_EXECUTE_WIDGETS=()

zinit wait lucid blockf atpull'zinit creinstall -q .' \
  light-mode for @zsh-users/zsh-completions

## zsh-autocomplete
# zinit ice wait"1" lucid
# zinit light marlonrichert/zsh-autocomplete

## docker completion
zinit ice wait"2" lucid as"completion"
zinit snippet https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker

## fast-syntax-highlighting
# zinit wait lucid \  # 遅延ロードすると autosuggestions のハイライトがおかしくなる
#   if"(( ${ZSH_VERSION%%.*} > 4.4))" \
#   atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
#   light-mode for @zdharma/fast-syntax-highlighting
# # fast-theme XDG:overlay  # 初回はこれの実行を忘れずに


## zshmarks
zinit ice wait"1" lucid
zinit light jocelynmallon/zshmarks

## clipcopy and clippaste function
zinit ice wait"2" lucid
zinit snippet 'OMZ::lib/clipboard.zsh'

## history editing
zinit ice wait"2" lucid
zinit light marlonrichert/zsh-hist

# ogham/exa, replacement for ls
# zinit ice wait"1" lucid from"gh-r" as"program" mv"exa* -> exa"
# zinit light ogham/exa

# direnv
zinit lucid from"gh-r" as"program" mv"direnv* -> direnv" pick"direnv" \
  atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' \
  src="zhook.zsh" light-mode for @direnv/direnv
local p=$PWD
while  [[ $p != '/' ]]; do
  if [[ -f $p/.envrc ]]; then
    direnv allow
    break
  fi
  p=$(dirname $p)
done

zinit wait"1" lucid blockf nocompletions \
  from"gh-r" as"program" mv"ripgrep* -> ripgrep" sbin'ripgrep/rg' \
  atclone'zinit creinstall -q BurntSushi/ripgrep' atpull'%atclone' \
  light-mode for @BurntSushi/ripgrep

zinit wait"1" lucid blockf nocompletions \
  from"gh-r" as"program" mv"fd* -> fd" sbin'fd/fd' \
  atclone'zinit creinstall -q sharkdp/fd' atpull'%atclone' \
  light-mode for @sharkdp/fd

zinit wait"1" lucid \
  from"gh-r" as"program" mv"bat* -> bat" sbin"bat/bat" \
  atload"alias cat=bat" \
  light-mode for @sharkdp/bat

zinit wait"1" lucid \
  from"gh-r" as"program" mv"exa* -> exa" sbin"exa/exa" \
  light-mode for @ogham/exa

zinit wait'1' lucid \
  light-mode for @soimort/translate-shell

# zinit wait'1' lucid \
#   from"gh-r" as"program" bpick'*lnx*' \
#   light-mode for @dalance/procs

# romkatv/powerlevel10k
zinit ice depth=1 atload'source ~/.p10k.zsh' nocd
zinit light romkatv/powerlevel10k

# # zdharma/zsh-diff-so-fancy
# zinit wait"2" lucid as"program" sbin"bin/git-dsf" \
#   light-mode for @zdharma/zsh-diff-so-fancy

# diff-so-fancy から乗り換え
zinit wait'1' lucid \
  from"gh-r" as"program" mv"delta* -> delta" sbin"delta/delta" \
  light-mode for @dandavison/delta

# fast-syntax-highlighting から乗り換え
# zinit ice wait"1" lucid
zinit light zsh-users/zsh-syntax-highlighting
ZSH_HIGHLIGHT_MAXLENGTH=512
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
# see https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/highlighters/main/main-highlighter.zsh
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=green'
ZSH_HIGHLIGHT_STYLES[global-alias]='bg=blue'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[globbing]='none'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=185'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=185'

## auto ls after changing directory
add-zsh-hook chpwd _ls_abbrev


# mkdir and cd
mkcd() {
  if [[ -d $1 ]]; then
    echo "$1 already exists!"
    cd $1
  else
    mkdir $1 && cd $1
  fi
}


# grep を除いて任意のプロセスを表示
pss() {
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
  BUFFER=$(\history -n -r 1 | peco --query "$BUFFER" --prompt "[hist]" --print-query | tail -1)
  CURSOR=${#BUFFER}
#  zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

fzf-select-history() {
    BUFFER="$(history -nr 1 | awk '!a[$0]++' | fzf --query "$BUFFER" | sed 's/\\n/\n/')"
    CURSOR=${#BUFFER}  # カーソルを文末に移動
    zle -R -c          # refresh
}
# zle -N fzf-select-history
# bindkey '^r' fzf-select-history

## search a destination from cdr list and cd the destination
peco-cdr() {
  local dest=$(cdr -l | sed -Ee 's/^[0-9]+\s+//' | peco --query "$BUFFER" --prompt "[dest]")
  if [[ -n "${dest}" ]]; then
    BUFFER="cd ${dest}"
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
  local source_files
  if git rev-parse 2> /dev/null; then
    source_files=$(git ls-files)
  else
    source_files=$(find . -type f)
  fi
  local selected_files=$(echo ${source_files} | peco --prompt "[file]" | tr '\n', ' ')

  BUFFER=${BUFFER}${selected_files}
  CURSOR=${#BUFFER}
  zle redisplay
}
zle -N peco-find-file
bindkey '^_' peco-find-file  # works by ^/

# shell integration 設定
export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# unset all environment variables and restart shell
resetenv() {
  local U=$USER
  local S=$SHELL
  local D=$DISPLAY
  for v in $(env | awk -F"=" '{print $1}'); do unset $v; done
  export USER=$U
  export SHELL=$S
  export DISPLAY=$D
  exec $SHELL -l
}

# ssh and tmux -CC
# https://gitlab.com/gnachman/iterm2/-/wikis/tmux-Integration-Best-Practices
tssh() {
  ssh -t $@ 'tmux -CC new -A -s main'
}

# set of set operations
union() {
  if [[ -p /dev/stdin ]]; then
    cat - $@ | awk '!x[$0]++'
  else
    cat $@ | awk '!x[$0]++'
  fi
}
isect() {
  if [[ -p /dev/stdin ]]; then
    cat - $@ | awk 'x[$0]++'
  else
    cat $@ | awk 'x[$0]++'
  fi
}
ssub() {
  local file1
  local file2
  if [[ -p /dev/stdin ]]; then
    file1=/dev/stdin
    file2=$1
  else
    file1=$1
    file2=$2
  fi
  comm -23 <(sort $file1) <(sort $file2)
}

cd() {
  if [[ $# -eq 1 && $1 = "--" ]]; then
    pushd +2
  else
    builtin cd $@
  fi
}

# https://qiita.com/yuyuchu3333/items/b10542db482c3ac8b059
_ls_abbrev() {
  local MAX_LINUM=20
  if [[ ! -r $PWD ]]; then
    return
  fi
  # -C : Force multi-column output.
  # -F : Append indicator (one of */=>@|) to entries.
  local ls_result=$(CLICOLOR_FORCE=1 COLUMNS=${COLUMNS} command ls -ACF --color=always | sed $'/^\e\[[0-9;]*m$/d')
  local ls_lines=$(echo "${ls_result}" | wc -l | tr -d ' ')

  if [[ ${ls_lines} -gt ${MAX_LINUM} ]]; then
    echo "${ls_result}" | head -3
    echo '...'
    echo "${ls_result}" | tail -3
    echo "$(command ls -1UA | wc -l | tr -d ' ') files exist"
  else
    echo "${ls_result}"
  fi
}

# jocelynmallon/zshmarks
bm() {
  if [[ $# == 0 ]]; then
    showmarks
    return 0
  fi
  local help_msg=$(cat << EOS
Usage: bm [<option>] [<name>]

  -l           list all bookmarks
  -a <name>    add current directory to bookmark
  -d <name>    delete <name> from bookmark
  -h           show this help
EOS
)
  local opt
  for opt do
    case "$opt" in
      '-h'|'--help') echo ${help_msg}; return 0 ;;
      '-l'|'--list') showmarks $2; return 0 ;;
      '-a'|'--add') bookmark $2; return 0 ;;
      '-d'|'--del'|'--delete') deletemark $2; return 0 ;;
      -*) echo "bm: illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2; return 1 ;;
      *) [[ -n "$1" ]] && jump "$1"; return 0 ;;
    esac
  done
}

lspath() {
  if [[ $# == 0 ]]; then
    local path_=$PWD
  else
    local path_=$(readlink -f $1)
  fi
  \ls -d1AH --color=tty ${path_}/*
}

les() {
  if [[ $# == 0 ]]; then
    ls
  elif [[ -f $1 ]]; then
    bat $@
  else
    ls $@
  fi
}

diff() {
  if (type colordiff &> /dev/null); then
    colordiff -us $@ | diff-highlight
  else
    command diff -u $@
  fi
}

# git add などの補完が効かなくなるのでコメントアウト
# git() {
#   if [[ $# > 0 ]]; then
#     command git $@
#   else
#     command git status
#   fi
# }

# LOAD SETTING FILES
source ${ZSHHOME}/.zshrc

if (which zprof > /dev/null 2>&1) ;then
  zprof
fi
