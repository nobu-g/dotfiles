# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZRCDIR="${ZBASEDIR}/.zshrc.d"

#--------------------------------#
# Base
#--------------------------------#
source-safe() { [[ -f "$1" ]] && source "$1" }
source "${ZRCDIR}/base.zsh"


#--------------------------------#
# Key bindings
#--------------------------------#
source "${ZRCDIR}/keybinding.zsh"


#--------------------------------#
# Completion
#--------------------------------#
source "${ZRCDIR}/completion.zsh"


#--------------------------------#
# Options
#--------------------------------#
source "${ZRCDIR}/option.zsh"


#--------------------------------#
# Plugins
#--------------------------------#
# typeset -g ZINIT_MOD_DEBUG=1  # debug mode
source "${ZRCDIR}/plugin.zsh"


#--------------------------------#
# Misc
#--------------------------------#
source "${ZRCDIR}/misc.zsh"


# Alias
source-safe "${ZBASEDIR}/.zaliases"


# Load environment-specific settings
source-safe "${ZENVDIR}/.zshrc"


# Profile
if (type zprof &> /dev/null); then
  zprof
fi
