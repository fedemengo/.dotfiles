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
