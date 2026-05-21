export OS=$(uname -s)
export ARCH=$(uname -p)

if [ "$OS" = "Darwin" ]; then
    export HOME=/Users/$(whoami)
elif [ "$OS" = "Linux" ]; then
    export HOME=/home/$(whoami)
fi

# if ZSH_VERBOSE_LOG is set, set log file else log to /dev/null
if [[ -n "$ZSH_VERBOSE_LOG" ]]; then
    export ZSH_SOURCING_LOG_FILE="/tmp/zshrc-sourcing.log"
else
    export ZSH_SOURCING_LOG_FILE="/dev/null"
fi

# base default config
if [[ -f ~/.dotfiles/.dotfiles-secret/.secret-zshrc ]]; then
  SECRET_DOTF="~/.dotfiles/.dotfiles-secret" source ~/.dotfiles/.dotfiles-secret/.secret-zshrc
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

DOTF=$HOME/.dotfiles
MYZSH="$DOTF"/.zsh

# enviromental variables
source $MYZSH/variables.zsh 2>>$ZSH_SOURCING_LOG_FILE >&2
# theme configuration

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh. and replace file
source $MYZSH/pl10k.zsh 2>>$ZSH_SOURCING_LOG_FILE >&2
# aliases, keybinds, plugins
source $MYZSH/utils.zsh 2>>$ZSH_SOURCING_LOG_FILE >&2
# helper functions
source $MYZSH/functions.zsh 2>>$ZSH_SOURCING_LOG_FILE >&2

source $MYZSH/local.zsh 2>>$ZSH_SOURCING_LOG_FILE >&2

if [[ -f "$HOME/.atuin/bin/env" ]]; then
    source "$HOME/.atuin/bin/env"
    eval "$(atuin init zsh)"
fi
