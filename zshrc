PATH=$PATH:$HOME/bin

source ~/.antigen/antigen.zsh

antigen use oh-my-zsh

DISABLE_AUTO_TITLE="true"

antigen bundle common-aliases
antigen bundle cp
antigen bundle extract
antigen bundle git
antigen bundle history

export DEFAULT_USER=`whoami`
# POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_middle"
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status vi_mode)
POWERLEVEL9K_STATUS_VERBOSE=false
POWERLEVEL9K_COLOR_SCHEME='light'

antigen theme bhilburn/powerlevel9k powerlevel9k

# Make ctrl + s work
vim()
{
    local STTYOPTS="$(stty --save)"
    stty stop '' -ixoff
    command vim "$@"
    stty "$STTYOPTS"
}

export VISUAL=vim
export EDITOR=$VISUAL

# VI-Mode
# general activation
bindkey -v

# set some nice hotkeys
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward

# make it more responsive
export KEYTIMEOUT=1

if [ -d $HOME/.zshrc.d ]; then
  for file in $HOME/.zshrc.d/*.zsh; do
    source $file
  done
fi

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

antigen apply

unalias rm
unalias cp
unalias mv

unsetopt share_history
setopt  NO_NOMATCH
setopt hist_ignore_all_dups
unset PAGER
