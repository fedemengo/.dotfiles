# base default config
if [[ -f ~/.dotfiles/.dotfiles-secret/.secret-zshrc ]]; then
  SECRET_DOTF=".dotfiles/.dotfiles-secret" source ~/.dotfiles/.dotfiles-secret/.secret-zshrc
else
  echo "secret zsh not found"
fi

export ZSH_SOURCING_LOG_FILE="/tmp/zshrc-sourcing.log"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

DOTF=$HOME/.dotfiles
MYZSH=$DOTF/.zsh
SYSDIG_DOTF=$DOTF/.dotfiles-sysdig

# enviromental variables
source $MYZSH/variables.zsh 2>>$ZSH_SOURCING_LOG_FILE >&2
# theme configuration
source $MYZSH/pl10k.zsh 2>>$ZSH_SOURCING_LOG_FILE >&2
#source $MYZSH/blox.zsh 2>$LOG_FILE
# aliases, keybinds, plugins
source $MYZSH/utils.zsh 2>>$ZSH_SOURCING_LOG_FILE >&2
# helper functions
source $MYZSH/functions.zsh 2>>$ZSH_SOURCING_LOG_FILE >&2

# work dotfiles
source $SYSDIG_DOTF/.sysdig-zshrc 2>>$ZSH_SOURCING_LOG_FILE >&2

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

#[[ -n $TMUX ]] && export TERM="xterm-256color"

