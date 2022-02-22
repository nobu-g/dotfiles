# ZINIT SETTINGS

# place above compinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
source "${ZINIT_HOME}/zinit.zsh"
ZINIT[COMPINIT_OPTS]="-C -d ${XDG_CACHE_HOME:-${HOME}/.cache}/zsh/zcompdump"
# If you place the source below compinit, then add those two lines after the source:
# autoload -Uz _zinit
# (( ${+_comps} )) && _comps[zinit]=_zinit

#--------------------------------#
# zinit extension
#--------------------------------#
# zinit light-mode for \
  # @zinit-zsh/z-a-readurl \
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

# zinit load zdharma-continuum/history-search-multi-word

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
#   light-mode for @zdharma-continuum/fast-syntax-highlighting
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

zinit wait'1' lucid \
  light-mode for @soimort/translate-shell

# romkatv/powerlevel10k
zinit ice depth=1 atload'source ~/.p10k.zsh' nocd
zinit light romkatv/powerlevel10k
ZLE_RPROMPT_INDENT=0

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
# requires `go install github.com/itchyny/fillin@latest`
# usage:
# $ fillin echo {{foo}} {{bar}}
# foo: Hello,
# bar: world
# Hello, world
zinit wait'1' lucid \
  light-mode for @itchyny/zsh-auto-fillin

# atuin
export ATUIN_NOBIND="true"
zinit lucid \
  light-mode for @ellie/atuin
bindkey '^t' _atuin_search_widget
