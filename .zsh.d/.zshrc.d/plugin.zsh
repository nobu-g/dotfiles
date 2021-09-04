# ZINIT SETTINGS

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
  # @zinit-zsh/z-a-bin-gem-node \
  # @zinit-zsh/z-a-patch-dl \
  # @zinit-zsh/z-a-unscope \
  # @zinit-zsh/z-a-default-ice \
  # @zinit-zsh/z-a-submods \
  # @zinit-zsh/z-a-man # -> require gem

zicompdef g='git'
zicompdef gti='git'
zicompdef l='ls'
zicompdef ll='ls'
zicompdef la='ls'
zicompdef lt='ls'
zicompdef lat='ls'
if (($+commands[docker])); then
  zicompdef d='docker'
fi
zicompdef zi='zinit'

# other themes: dircolors.ansi-dark, dircolors.ansi-light, dircolors.256dark
zinit ice atload'[[ -e $HOME/.zsh-dircolors.config ]] || setupsolarized dircolors.ansi-universal' \
  atload'zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"'
zinit light 'joel-porquet/zsh-dircolors-solarized'

# zinit ice wait"1" lucid
# zinit light zsh-users/zsh-history-substring-search

# zinit load zdharma/history-search-multi-word

#--------------------------------#
# completion
#--------------------------------#
## zsh-autosuggestions
zinit wait"1" lucid atload"unset ZSH_AUTOSUGGEST_USE_ASYNC; _zsh_autosuggest_start" \
  atinit"zicompinit; zicdreplay -q" \
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
zinit wait lucid blockf atpull'zinit creinstall -q .' has'docker' for \
  as'completion' is-snippet \
  'https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker'

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
# $ echo あいうえお
# などとすると文字化けしてしまうのでコメントアウト
# zinit ice wait"2" lucid
# zinit light marlonrichert/zsh-hist

# direnv
zinit lucid from"gh-r" as"program" mv"direnv* -> direnv" pick"direnv" \
  atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' \
  src="zhook.zsh" light-mode for @direnv/direnv
p=$PWD
while [[ $p != '/' ]]; do
  if [[ -f $p/.envrc ]]; then
    direnv allow
    break
  fi
  p=$(dirname $p)
done

zinit wait'1' lucid blockf nocompletions \
  from"gh-r" as"program" mv"ripgrep-* -> ripgrep" pick'ripgrep/rg' \
  atclone'zinit creinstall -q BurntSushi/ripgrep' atpull'%atclone' \
  light-mode for @BurntSushi/ripgrep
export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME:-$HOME/.config}/ripgrep/config"

zinit wait'1' lucid blockf nocompletions \
  from"gh-r" as"program" mv"fd-* -> fd" pick'fd/fd' \
  atclone'zinit creinstall -q sharkdp/fd' atpull'%atclone' \
  light-mode for @sharkdp/fd

zinit wait lucid \
  from"gh-r" as"program" mv"bat-* -> bat" cp"bat/autocomplete/bat.zsh -> _bat" pick"bat/bat" \
  atload"alias cat='bat -p'" \
  light-mode for @sharkdp/bat

zinit wait lucid blockf nocompletions \
  from"gh-r" as"program" mv"lsd* -> lsd" pick"lsd/lsd" \
  atclone'zinit creinstall -q Peltoche/lsd' atpull'%atclone' \
  light-mode for @Peltoche/lsd

zinit wait'1' lucid \
  from"gh-r" as"program" mv"exa* -> exa" pick"bin/exa" \
  light-mode for @ogham/exa

zinit wait'1' lucid \
  light-mode for @soimort/translate-shell

# zinit wait'1' lucid \
#   from"gh-r" as"program" bpick'*lnx*' \
#   light-mode for @dalance/procs

# romkatv/powerlevel10k
zinit ice depth=1 atload'source ~/.p10k.zsh' nocd
zinit light romkatv/powerlevel10k
ZLE_RPROMPT_INDENT=0

zinit wait'1' lucid \
  from"gh-r" as"program" mv"delta* -> delta" pick"delta/delta" \
  atload"alias diff=delta" \
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

# https://itchyny.hatenablog.com/entry/2017/06/12/090000
# requires `go get github.com/itchyny/fillin`
# usage:
# $ fillin echo {{foo}} {{bar}}
# foo: Hello,
# bar: world
# Hello, world
zinit wait'1' lucid \
  light-mode for @itchyny/zsh-auto-fillin

zinit wait'1' lucid \
  light-mode for @paulirish/git-open

# atuin
zinit lucid \
  light-mode for @ellie/atuin
export ATUIN_NOBIND="true"
eval "$(atuin init zsh)"
bindkey '^r' _atuin_search_widget
