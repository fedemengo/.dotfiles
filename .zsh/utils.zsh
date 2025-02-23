#############################################################################
############################# OTHER CONFIGURATION ###########################
#############################################################################

  # Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

  # Uncomment the following line to use hyphen-insensitive completion. Case
  # sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

  # Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

  # Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

  # Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

  # Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

  # Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

  # Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

  # Uncomment the following line if you want to disable marking untracked files
  # under VCS as dirty. This makes repository status check for large repositories
  # much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

  # Uncomment the following line if you want to change the command execution time
  # stamp shown in the history command output.
  # The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"
setopt HIST_IGNORE_ALL_DUPS  # do not put duplicated command into history list
setopt HIST_SAVE_NO_DUPS  # do not save duplicated command
setopt HIST_REDUCE_BLANKS  # remove unnecessary blanks
setopt INC_APPEND_HISTORY_TIME  # append command to history file immediately after execution
setopt EXTENDED_HISTORY  # record command start time

  # Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

  # Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
  # Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/

eval "$(jump shell)"

# eval "$(conda init zsh)"

plugins=(
  encode64
  docker
  docker-compose
  kubectl
  kubectx
  zsh-autosuggestions
  zsh-fzf-history-search
)

export ZSH_FZF_HISTORY_SEARCH_DATES_IN_SEARCH=1

source $ZSH/oh-my-zsh.sh
#source $ZSH/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
#zstyle ':autocomplete:*' default-context history-incremental-search-backward

export PATH="${PATH}:${HOME}/.rbenv/shims"
export RBENV_SHELL=zsh

#command rbenv rehash 2>/dev/null
rbenv() {
  local command
  command="${1:-}"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  rehash|shell)
    eval "$(rbenv "sh-$command" "$@")";;
  *)
    command rbenv "$command" "$@";;
  esac
}

zle -N tab_list
zle -N forward-kill-word
zle -N sudo-util
zle -N redo-sudo
zle -N home

# History
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt append_history           # Dont overwrite history
setopt extended_history         # Also record time and duration of commands.
setopt share_history            # Share history between multiple shells
setopt hist_expire_dups_first   # Clear duplicates when trimming internal hist.
setopt hist_find_no_dups        # Dont display duplicates during searches.
setopt hist_ignore_dups         # Ignore consecutive duplicates.
setopt hist_ignore_all_dups     # Remember only one unique copy of the command.
setopt hist_reduce_blanks       # Remove superfluous blanks.
setopt hist_save_no_dups        # Omit older commands in favor of newer ones.

# Changing directories
setopt pushd_ignore_dups        # Dont push copies of the same dir on stack.
setopt pushd_minus              # Reference stack entries with "-".

bindkey "^a" beginning-of-line
bindkey "^e" end-of-line
bindkey "^g" forward-word
bindkey "^b" backward-word
bindkey "^k" kill-line
bindkey "^y" accept-and-hold
bindkey "^d" forward-kill-word
bindkey "^w" backward-kill-word
bindkey "^u" backward-kill-line
#bindkey "^R" history-incremental-pattern-search-backward
bindkey "^[k" up-history
bindkey "^[j" down-history
bindkey "^i" expand-or-complete-prefix
bindkey "^I" tab_list
bindkey "^[[Z" reverse-menu-complete
bindkey "^ " autosuggest-accept

bindkey "^s" sudo-util
bindkey "^h" home

zstyle ':completion:*' menu select
zstyle ':completion:*' insert-tab false
zstyle ':completion:*' rehash true

# case-insensitive (all), partial-word and then substring completion
zstyle ":completion:*" matcher-list "m:{a-zA-Z}={A-Za-z}" "r:|[._-]=* r:|=*" "l:|=* r:|=*"
zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS}

#############################################################################
############################## ALIASES ######################################
#############################################################################

if [ "$OS" = "Darwin" ]; then
    MATLAB_PATH=$(ls -d /Applications/MATLAB*.app 2>/dev/null | head -1)
    if [ -n "$MATLAB_PATH" ]; then
        alias matlab="$MATLAB_PATH/bin/matlab -nodesktop -nojvm"
    fi
fi

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias md='mkdir -p'

alias l='gls -oh -X --group-directories-first --color=always'
alias ll='gls -oah -X --group-directories-first --color=always'
alias lld='gls -ld -X --group-directories-first --color=always */'
alias pi='ssh pi@192.168.178.100 2>/dev/null'
alias pi3='ssh pi@192.168.178.101 2>/dev/null'
alias ubu='ssh fedemengo@192.168.178.121'
alias pifs='sshfs -o allow_other pi@192.168.178.100:/mnt/hdd/ /mnt/hdd'
alias pifs3='rclone mount --daemon pi3::STORAGE/ /mnt/hdd'
#alias pifs3='sshfs -o allow_other pi@192.168.178.101:/mnt/hdd/ /mnt/hdd'
alias upifs='fusermount -u /mnt/hdd'
alias df='df -h'                          # human-readable sizes
alias du='du -h'
alias free='free -m'                      # show sizes in MB
alias diff='colordiff'

alias ...='../..'
alias ....='../../..'
alias .....='../../../..'
alias ......='../../../../..'

alias -- -='cd -'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

alias gst='git status'
alias gs='git status'
alias gut='git'
alias got='git'
alias gi='git'
alias g='git'

alias push='git push'
alias pull='git pull'
alias pad='git pad'
alias com='git commit -m'
alias gff='git diff'
alias co='git checkout'

alias p3='python3'

alias rename='perl-rename'
alias h='history -t "%d.%m.%y-%H:%M:%S"'

alias vim='nvim'
alias n='nvim'
alias v='nvim'
alias vi='nvim'

alias vrc='vim $HOME/.nvimrc'
alias zrc='vim $HOME/.dotfiles/.zshrc'
alias zd='vim $HOME/.dotfiles/.zsh'

alias z='zoxide'

alias k='kubecolor --force-colors'
alias kr='kubecolor'
alias kx='kubectx'
alias ks='kubens'
alias kgp='k get pods --all-namespaces'
alias gimg='rg -i image: -A5'

alias dockerps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Command}}\t{{.Status}}\t{{.Ports}}"'
alias dockermall='docker rm -f $(docker ps -a -q)'
alias dockercmds='docker ps --no-trunc --format "table {{.Names}}\t{{.Command}}\t{{.Status}}"'

