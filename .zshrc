
#############################################################################
######################## ENVIRONMENT VARIABLES ##############################
#############################################################################

export TERM="terminator"
export ZSH=$HOME/.oh-my-zsh
export PATH=$HOME/bin:/usr/local/bin:$PATH

export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_PAPER="en_US.UTF-8"
export LC_NAME="en_US.UTF-8"
export LC_ADDRESS="en_US.UTF-8"
export LC_TELEPHONE="en_US.UTF-8"
export LC_MEASUREMENT="en_US.UTF-8"
export LC_IDENTIFICATION="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export LESS="--tabs=4 --no-init --LONG-PROMPT --ignore-case --quit-if-one-screen --RAW-CONTROL-CHARS"
export LS_COLORS="di=38;5;38:ex=38;5;82"

export GOPATH="${HOME}/.go"
export GOROOT="/usr/lib/go"
export PATH="$PATH:$GOPATH/bin:$GOROOT/bin"

export RUBY_VERSION="2.5.0"
export PATH="${PATH}:${HOME}/.gem/ruby/${RUBY_VERSION}/bin"

export EDITOR="$(which vim)"

# python local stuff
PYTHON_LOC="${HOME}/.local/bin"
export PATH="${PATH}:${PYTHON_LOC}"

# Just for testing algo-and-ds repo
export PATH="${PATH}:${HOME}/projects/algorithms-and-data-structures"

title=$(todo.sh ls | tail -n 1)
todos=$(todo.sh ls | head -n $(($(todo.sh ls | wc -l)-2)) | sort)
echo "$(tput setaf 197)$title $(tput sgr0)"; echo $todos; echo "";

ZSH_THEME="powerlevel9k/powerlevel9k"
POWERLEVEL9K_MODE="powerline"
ZSH_DISABLE_COMPFIX=true

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

EMPTY_BG=232
DEFAULT_FG=0

POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=false

POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="\U1F892 " # \u25B8 "

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
POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=226
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

# User
POWERLEVEL9K_USER_BACKGROUND=$EMPTY_BG
POWERLEVEL9K_USER_FOREGROUNG=076

prompt_my_todo() {
  if $(hash todo.sh 2>&-); then
    count=$(todo.sh ls | egrep "TODO: [0-9]+ of ([0-9]+) tasks shown" | awk '{ print $4 }')
    if [[ "$count" = <-> ]]; then
      "$1_prompt_segment" "$0" "$2" "244" "$DEFAULT_COLOR" "TODO: $count"
    fi
  fi
}

POWERLEVEL9K_USER_TEMPLATE="%n"
prompt_my_user() {
  local current_state="DEFAULT"
  typeset -AH user_state
  if [[ "$POWERLEVEL9K_ALWAYS_SHOW_USER" == true ]] || [[ "$(whoami)" != "$DEFAULT_USER" ]]; then
    if [[ $(print -P "%#") == '#' ]]; then
      user_state=(
        "STATE"               "ROOT"
        "CONTENT"             "${POWERLEVEL9K_USER_TEMPLATE}"
        "BACKGROUND_COLOR"    "${POWERLEVEL9K_USER_BACKGROUND}"
        "FOREGROUND_COLOR"    "${POWERLEVEL9K_USER_FOREGROUNG}"
        "VISUAL_IDENTIFIER"   ""
      )
    elif sudo -n true 2>/dev/null; then
      user_state=(
        "STATE"               "SUDO"
        "CONTENT"             "${POWERLEVEL9K_USER_TEMPLATE}"
        "BACKGROUND_COLOR"    "${POWERLEVEL9K_USER_BACKGROUND}"
        "FOREGROUND_COLOR"    "${POWERLEVEL9K_USER_FOREGROUNG}"
        "VISUAL_IDENTIFIER"   ""
      )
    else
      user_state=(
        "STATE"               "DEFAULT"
        "CONTENT"             "${POWERLEVEL9K_USER_TEMPLATE}"
        "BACKGROUND_COLOR"    "${POWERLEVEL9K_USER_BACKGROUND}"
        "FOREGROUND_COLOR"    "${POWERLEVEL9K_USER_FOREGROUNG}"
        "VISUAL_IDENTIFIER"   ""
      )
    fi
    "$1_prompt_segment" "${0}_${user_state[STATE]}" "$2" "${user_state[BACKGROUND_COLOR]}" "${user_state[FOREGROUND_COLOR]}" "${user_state[CONTENT]}" "${user_state[VISUAL_IDENTIFIER]}"
  fi
}

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(my_user dir vcs)
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

plugins=(
  web-search
  encode64
  zsh-autosuggestions
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

function forward-kill-word {
    zle forward-word
    zle backward-kill-word
}
zle -N forward-kill-word

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
bindkey "^y" accept-and-hold
bindkey "^ " forward-char
bindkey "^d" forward-kill-word
bindkey "^w" backward-kill-word
bindkey "^u" backward-kill-line
bindkey "^R" history-incremental-pattern-search-backward
bindkey "^[k" up-history
bindkey "^[j" down-history
bindkey "^i" expand-or-complete-prefix
bindkey "^I" tab_list
bindkey "^[[Z" reverse-menu-complete

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

function colors256() {
	for code ({000..255}) 
		print -P -- "$code: %F{$code} color%f"
}

function connect(){
	if [[ "$#" -eq "0" ]]
	then
		echo "output identifier is required"
	else
		xrandr --output "$1" --auto --output eDP1 --auto --right-of "$1"
	fi
}

function disconnect(){
	if [[ "$#" -eq "0" ]]
	then
		echo "output identifier is required"
	else
		xrandr --output "$1" --off
	fi
}

function unmute() {
	amixer sset Master unmute
	amixer sset Speaker unmute
}

if [ $commands[kubectl] ]; then
	source <(kubectl completion zsh)
fi

# # ex - archive extractor # usage: ex <file>
function ex() {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

#############################################################################
############################## ALIASES ######################################
#############################################################################

alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias pi='ssh pi@192.168.1.100'
alias pifs='sshfs pi@192.168.1.100:/mnt/HDD/ /mnt/hdd'
alias todo='todo.sh'
alias rs='repos-stat --no-clean --no-broken'
alias df='df -h'                          # human-readable sizes
alias du='du -h --max-depth=1'
alias free='free -m'                      # show sizes in MB
alias diff='colordiff'

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

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

alias md='mkdir -p'

# List directory contents
alias l="ls -ls --block-size=M"
alias ll='ls -lah'

