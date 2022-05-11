# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

HOME=/home/fedemengo
DOTF=$HOME/.dotfiles
MYZSH=$DOTF/.zsh
SYSDIG_DOTF=$DOTF/.dotfiles-sysdig

# enviromental variables
source $MYZSH/variables.zsh 2>/dev/null
# theme configuration
source $MYZSH/pl10k.zsh 2>/dev/null
#source $MYZSH/blox.zsh 2>/dev/null
# aliases, keybinds, plugins
source $MYZSH/utils.zsh 2>/dev/null
# helper functions
source $MYZSH/functions.zsh 2>/dev/null

# work dotfiles
source $SYSDIG_DOTF/.zshrc 2>/dev/null

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

#[[ -n $TMUX ]] && export TERM="xterm-256color"

