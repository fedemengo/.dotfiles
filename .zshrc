# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

HOME=/home/fedemengo
MYZSH=$HOME/.dotfiles/.zsh

# enviromental variables
source $MYZSH/variables.zsh 2>/dev/null
# theme configuration
source $MYZSH/pl10k.zsh 2>/dev/null
#source $MYZSH/blox.zsh 2>/dev/null
# aliases, keybinds, plugins
source $MYZSH/utils.zsh 2>/dev/null
# helper functions
source $MYZSH/functions.zsh 2>/dev/null

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

#[[ -n $TMUX ]] && export TERM="xterm-256color"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/federico.mengozzi/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/federico.mengozzi/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/federico.mengozzi/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/federico.mengozzi/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


eval $(thefuck --alias)
export PATH="/usr/local/opt/llvm/bin:$PATH"
export PATH="/usr/local/opt/binutils/bin:$PATH"
