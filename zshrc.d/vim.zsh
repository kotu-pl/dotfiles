# Make ctrl + s work                                                            
vim()                                                                           
{                                                                               
    local STTYOPTS="$(stty --save)"                                             
    stty stop '' -ixoff                                                         
    command vim "$@"                                                            
    stty "$STTYOPTS"                                                            
}                                                                               
                                                                                
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
