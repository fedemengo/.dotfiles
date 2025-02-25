export OS=$(uname -s)
export ARCH=$(uname -p)

if [ "$OS" = "Darwin" ]; then
    export HOME=/Users/$(whoami)
elif [ "$OS" = "Linux" ]; then
    export HOME=/home/$(whoami)
fi

# base default config
if [[ -f ~/.dotfiles/.dotfiles-secret/.secret-zshrc ]]; then
  SECRET_DOTF="~/.dotfiles/.dotfiles-secret" source ~/.dotfiles/.dotfiles-secret/.secret-zshrc
fi

export ZSH_SOURCING_LOG_FILE="/tmp/zshrc-sourcing.log"

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

if command -v atuin &> /dev/null; then
    # helper functions
    source $MYZSH/atuin.zsh 2>>$ZSH_SOURCING_LOG_FILE >&2
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

