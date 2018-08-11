
#############################################################################
######################## ENVIRONMENT VARIABLES ##############################
#############################################################################

export TERM="xterm-256color"
export ZSH=$HOME/.oh-my-zsh
export PATH=$HOME/bin:/usr/local/bin:$PATH

export LANG=en_US.UTF-8

export LESS="--tabs=4 --no-init --LONG-PROMPT --ignore-case --quit-if-one-screen --RAW-CONTROL-CHARS"
export LS_COLORS="di=38;5;38:ex=38;5;82"

export GOPATH=${HOME}/Projects/go
export PATH="$PATH:$GOPATH/bin"

RUBY_VERSION="2.5.0"
export PATH="${PATH}:${HOME}/.gem/ruby/${RUBY_VERSION}/bin"

export EDITOR="$(which vim)"

export TERM="xterm-256color"

title=$(todo.sh ls | tail -n 1)
todos=$(todo.sh ls | head -n $(($(todo.sh ls | wc -l)-2)))
echo "$(tput setaf 1)$title $(tput sgr0)"; echo $todos;

ZSH_THEME="powerlevel9k/powerlevel9k"
POWERLEVEL9K_MODE="powerline"

#############################################################################
####################### POWERLEVEL9K CONFIGURATION ##########################
#############################################################################

###################### REMOVE/EDIT ICONS ####################
#POWERLEVEL9K_VCS_BOOKMARK_ICON="\uF27B"
#POWERLEVEL9K_VCS_COMMIT_ICON="\uF221"
#POWERLEVEL9K_VCS_REMOTE_BRANCH_ICON="\u2192"
#POWERLEVEL9K_VCS_GIT_GITHUB_ICON="\uF113"
#POWERLEVEL9K_VCS_GIT_BITBUCKET_ICON="\uF171"
#POWERLEVEL9K_VCS_SVN_ICON="(svn)"

POWERLEVEL9K_FOLDER_ICON=""
POWERLEVEL9K_HOME_ICON=""
POWERLEVEL9K_HOME_SUB_ICON=""
POWERLEVEL9K_LOCK_ICON=""
POWERLEVEL9K_ETC_ICON=""

POWERLEVEL9K_NETWORK_ICON=""

EMPTY_BG=234
DEFAULT_FG=0

POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=false

POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="\u25B8 "

POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""
POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=""
POWERLEVEL9K_LEFT_SEGMENT_END_SEPARATOR=""
POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""
POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=""

# Status
POWERLEVEL9K_CUSTOM_ERRNO=true
POWERLEVEL9K_MY_STATUS_OK=true
POWERLEVEL9K_MY_STATUS_CROSS=true
POWERLEVEL9K_MY_STATUS_OK_BACKGROUND=$EMPTY_BG
POWERLEVEL9K_MY_STATUS_ERROR_BACKGROUND=$EMPTY_BG

# Dir
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"

POWERLEVEL9K_DIR_HOME_FOREGROUND="38;5;39"
POWERLEVEL9K_DIR_HOME_BACKGROUND=$EMPTY_BG
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="38;5;39"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND=$EMPTY_BG
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="38;5;39"
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND=$EMPTY_BG
POWERLEVEL9K_DIR_ETC_FOREGROUND="38;5;39"
POWERLEVEL9K_DIR_ETC_BACKGROUND=$EMPTY_BG

# VCS
POWERLEVEL9K_VCS_GIT_ICON=""
POWERLEVEL9K_VCS_GIT_GITHUB_ICON=""
POWERLEVEL9K_VCS_COMMIT_ICON="#"
POWERLEVEL9K_CHANGESET_HASH_LENGTH=7
POWERLEVEL9K_HIDE_BRANCH_ICON=true
POWERLEVEL9K_SHOW_CHANGESET=true

POWERLEVEL9K_VCS_CLEAN_FOREGROUND=041
POWERLEVEL9K_VCS_CLEAN_BACKGROUND=$EMPTY_BG
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=197
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=$EMPTY_BG
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=227
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=$EMPTY_BG

# TODO
POWERLEVEL9K_MY_TODO_BACKGROUND=$EMPTY_BG
POWERLEVEL9K_MY_TODO_FOREGROUND=208

# Execution time
POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0
POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=$EMPTY_BG
POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND="red"
POWERLEVEL9K_EXECUTION_TIME_ICON="s" #"\u23F1"

# BG jobs
POWERLEVEL9K_BACKGROUND_JOBS_ICON=""
POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=135
POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND=$EMPTY_BG

# IP
POWERLEVEL9K_IP_BACKGROUND=$EMPTY_BG
POWERLEVEL9K_IP_FOREGROUND=087

# Time
POWERLEVEL9K_TIME_BACKGROUND=$EMPTY_BG
POWERLEVEL9K_TIME_FOREGROUND="white"
POWERLEVEL9K_TIME_FORMAT='%D{%H:%M}'
POWERLEVEL9K_TIME_ICON=""

prompt_my_todo() {
  if $(hash todo.sh 2>&-); then
    count=$(todo.sh ls | egrep "TODO: [0-9]+ of ([0-9]+) tasks shown" | awk '{ print $4 }')
    if [[ "$count" = <-> ]]; then
      "$1_prompt_segment" "$0" "$2" "244" "$DEFAULT_COLOR" "TODO: $count"
    fi
  fi
}

function colors256() {
	for code ({000..255}) 
		print -P -- "$code: %F{$code} color%f"
}

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time background_jobs my_todo)

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

  # Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

  # Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
  # Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
  # Example format: plugins=(rails git textmate ruby lighthouse)
  # Add wisely, as too many plugins slow down shell startup.

plugins=(
  git
  web-search
  encode64
  zsh-autosuggestions
  bd
  catimg
)

source $ZSH/oh-my-zsh.sh

function tab_list {
	if [[ $#BUFFER == 0 ]]; then
		BUFFER="ls "
		CURSOR=3
		zle list-choices
		zle backward-kill-word
	else
		zle expand-or-complete
	fi
}
zle -N tab_list

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
bindkey "^f" forward-word
bindkey "^b" backward-word
bindkey "^k" kill-line
bindkey "^d" delete-char
bindkey "^y" accept-and-hold
bindkey "^w" backward-kill-word
bindkey "^u" backward-kill-line
bindkey "^R" history-incremental-pattern-search-backward
bindkey "^F" history-incremental-pattern-search-forward

# Do not require a space when attempting to tab-complete.
bindkey "^i" expand-or-complete-prefix
bindkey '^I' tab_list

# Fixes for alt-backspace and arrows keys
bindkey '^[^?' backward-kill-word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

zstyle ':completion:*' menu select
zstyle ':completion:*' insert-tab false
zstyle ':completion:*' rehash true
# case-insensitive (all), partial-word and then substring completion
zstyle ":completion:*" matcher-list \
  "m:{a-zA-Z}={A-Za-z}" \
  "r:|[._-]=* r:|=*" \
  "l:|=* r:|=*"
zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS}

#############################################################################
############################# CONFIGURATION #################################
#############################################################################

if [ $commands[kubectl] ]; then
	source <(kubectl completion zsh)
fi

#############################################################################
############################## ALIASES ######################################
#############################################################################

alias ll="ls -ls --block-size=M"
alias cp="cp -i"
alias pi='ssh pi@192.168.1.100'
alias pifs='sshfs pi@192.168.1.100:/mnt/HDD/ /mnt/HDD'
alias todo='todo.sh'
alias vscode='code-insiders'
alias rs='repos-stat --no-clean --no-broken'

