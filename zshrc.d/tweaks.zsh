# General

# TODO, nice options from: https://github.com/ricbra/zsh-config/blob/master/zshrc
# ? DISABLE_AUTO_TITLE="true" 
# ? export DEFAULT_USER=`whoami`

## make it more responsive
export KEYTIMEOUT=1
export VISUAL=vim
export EDITOR=$VISUAL
export TERM=xterm-256color

# VIM mode 
bindkey -v

## Make ctrl + s work                                                            
vim()
{
    local STTYOPTS="$(stty --save)"
    stty stop '' -ixoff
    command vim "$@"
    stty "$STTYOPTS"
}

bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward
bindkey '^k' kill-line
bindkey '^u' backward-kill-line

function zle-line-init zle-keymap-select {
    VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
    RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $EPS1"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

# b to go back one word
# 2b to go back two words
# dw to delete a word
# dd to delete the entire line
# d$ to delete from the current cursor position to the end of the line
# d0 to delete from the current cursor position to the beginning of the line
# w to go forward one word, and so forth

# History

HISTFILE=~/.histfile                                                            
HISTSIZE=10000000                                                                   
SAVEHIST=10000000
HISTORY_IGNORE="tp *"

setopt share_history                                                          
setopt hist_ignore_all_dups                                                     
setopt hist_ignore_space

# Tweaks 
## git issue fix (zsh: no matches found: HEAD^)
setopt NO_NOMATCH                                                              
unset PAGER 

##
bindkey '^ ' autosuggest-accept
