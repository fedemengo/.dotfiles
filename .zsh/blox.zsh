
ZSH_THEME="blox-zsh-theme/blox"

# Define some colors
LIGHT_GREEN=76
LIGHT_BLUE=38
GREEN=2

BLOX_CONF__PROMPT_PREFIX=""

# Prompt symbol
BLOX_BLOCK__SYMBOL_COLOR="white"
BLOX_BLOCK__SYMBOL_EXIT_COLOR=${BLOX_BLOCK__SYMBOL_COLOR}
BLOX_BLOCK__SYMBOL_SYMBOL="\U1F892"

BLOX_BLOCK__SYMBOL_EXIT_SYMBOL=${BLOX_BLOCK__SYMBOL_SYMBOL}

# User
BLOX_BLOCK__HOST_USER_SHOW_ALWAYS="true"
BLOX_BLOCK__HOST_USER_COLOR=${LIGHT_GREEN}

# Git
BLOX_BLOCK__GIT_DIRTY_SYMBOL="?"
BLOX_BLOCK__GIT_STASHED_SYMBOL="\U235F"
BLOX_BLOCK__GIT_BRANCH_COLOR="green"
#BLOX_BLOCK__GIT_COMMIT_COLOR="gray"
BLOX_BLOCK__GIT_STASHED_COLOR="gray"

BLOX_BLOCK__DIR_COLOR=${LIGHT_BLUE}
BLOX_BLOCK__DIR_LEN=3


function blox_block__user_host() {
	local user_color=$BLOX_BLOCK__HOST_USER_COLOR

	[[ $USER == "root" ]] && user_color=$BLOX_BLOCK__HOST_USER_ROOT_COLOR

	local result=""

	# Check if the user info is needed
	if [[ $BLOX_BLOCK__HOST_USER_SHOW_ALWAYS != false ]] || [[ $(whoami | awk '{print $1}') != $USER ]]; then
		result+="%F{$user_color]%}%n%{$reset_color%}"
	fi

	# Check if the machine name is needed
	if [[ $BLOX_BLOCK__HOST_MACHINE_SHOW_ALWAYS != false ]] || [[ -n $SSH_CONNECTION ]]; then
		[[ $result != "" ]] && result+="@"
		result+="%F{${BLOX_BLOCK__HOST_MACHINE_COLOR}]%}%m%{$reset_color%}"
	fi

	if [[ $result != "" ]]; then
		echo "$result"
	fi
}

function blox_block__dir() {
    LEN=${BLOX_BLOCK__DIR_LEN}
    output="%F{${BLOX_BLOCK__DIR_COLOR}}"

    DIR=${PWD//${HOME}/\~}
    if [[ "${PWD}" != "${HOME}"* ]]; then
        output+="/"
        DIR=${PWD}
    fi

    DIRS=(`echo ${DIR} | tr '/' '\n'`)
    output+="${DIRS[1]}"

    for ((i=2; i<=${#DIRS[@]}; i++))
    do
        dir=${DIRS[$i]}
        len=${#dir}
        # print last folder in its entirety
        if [ ${i} -eq ${#DIRS[@]} ]; then
            output+="/${DIRS[-1]}"
        else
            # reduce length of previous folder
            if [ ${len} -gt ${LEN} ]; then
                n=$((len-LEN))
                output+=`echo -n "/${dir}" | sed "s/.\{$n\}$//g"`
                output+=`echo -n -e "\U2026"`
            else
                output+=`echo -n "/${dir}"`
            fi
        fi
    done
    output+="%{$reset_color%}"
    echo ${output}
}

# ---------------------------------------------
# Git block options

# Colors
BLOX_BLOCK__GIT_BRANCH_COLOR="${BLOX_BLOCK__GIT_BRANCH_COLOR:-242}"

# Commit hash
BLOX_BLOCK__GIT_COMMIT_SHOW="${BLOX_BLOCK__GIT_COMMIT_SHOW:-true}"
BLOX_BLOCK__GIT_COMMIT_COLOR="${BLOX_BLOCK__GIT_COMMIT_COLOR:-magenta}"

# Clean
BLOX_BLOCK__GIT_CLEAN_COLOR="${BLOX_BLOCK__GIT_CLEAN_COLOR:-green}"
BLOX_BLOCK__GIT_CLEAN_SYMBOL="${BLOX_BLOCK__GIT_CLEAN_SYMBOL:-✔}"

# Dirty
BLOX_BLOCK__GIT_DIRTY_COLOR="11"
BLOX_BLOCK__GIT_DIRTY_SYMBOL="!"
BLOX_BLOCK__GIT_DIRTY_COLOR="${BLOX_BLOCK__GIT_DIRTY_COLOR:-yellow}"
BLOX_BLOCK__GIT_DIRTY_SYMBOL="${BLOX_BLOCK__GIT_DIRTY_SYMBOL:-!}"

# Untracked
BLOX_BLOCK__GIT_UNTRACKED_COLOR="${BLOX_BLOCK__GIT_UNTRACKED_COLOR:-red}"
BLOX_BLOCK__GIT_UNTRACKED_SYMBOL="${BLOX_BLOCK__GIT_UNTRACKED_SYMBOL:-?}"

BLOX_BLOCK__GIT_UNPUSHED_COLOR="39"

# ---------------------------------------------
# Themes

BLOX_BLOCK__GIT_THEME_CLEAN="%F{${BLOX_BLOCK__GIT_CLEAN_COLOR}]%}$BLOX_BLOCK__GIT_CLEAN_SYMBOL%{$reset_color%}"
BLOX_BLOCK__GIT_THEME_DIRTY="%F{${BLOX_BLOCK__GIT_DIRTY_COLOR}]%}$BLOX_BLOCK__GIT_DIRTY_SYMBOL%{$reset_color%}"
BLOX_BLOCK__GIT_THEME_UNTRACKED="%F{${BLOX_BLOCK__GIT_UNTRACKED_COLOR}]%}$BLOX_BLOCK__GIT_UNTRACKED_SYMBOL%{$reset_color%}"
BLOX_BLOCK__GIT_THEME_STASHED="%F{${BLOX_BLOCK__GIT_STASHED_COLOR}]%}$BLOX_BLOCK__GIT_STASHED_SYMBOL%{$reset_color%}"
BLOX_BLOCK__GIT_THEME_UNPULLED="%F{${BLOX_BLOCK__GIT_UNPULLED_COLOR}]%}$BLOX_BLOCK__GIT_UNPULLED_SYMBOL%{$reset_color%}"
BLOX_BLOCK__GIT_THEME_UNPUSHED="%F{${BLOX_BLOCK__GIT_UNPUSHED_COLOR}]%}$BLOX_BLOCK__GIT_UNPUSHED_SYMBOL%{$reset_color%}"

# ---------------------------------------------
# Helper functions

function set_commit_color() {
    local repo_status=$1
    local color=${BLOX_BLOCK__GIT_CLEAN_COLOR}
    (((repo_status & 1) == 1)) && color=${BLOX_BLOCK__GIT_UNTRACKED_COLOR}
    (((repo_status & 2) == 2)) && color=${BLOX_BLOCK__GIT_DIRTY_COLOR}
    echo "${color}"
}

# Echo the appropriate symbol for branch's status
function my_status() {
  if [[ -z "$1" ]]; then
    echo " $BLOX_BLOCK__GIT_THEME_CLEAN"
  else
    (((repo_status & 2) == 2)) && echo -n " $BLOX_BLOCK__GIT_THEME_DIRTY"
    (((repo_status & 1) == 1)) && echo -n " $BLOX_BLOCK__GIT_THEME_UNTRACKED"
  fi
}

# Echo the appropriate symbol if there are stashed files
function my_stashed_status() {
  if $(command git rev-parse --verify refs/stash &> /dev/null); then
    local stash_entry=$(command git stash list | wc -l)
    echo " %F{${BLOX_BLOCK__GIT_STASHED_COLOR}]%}${BLOX_BLOCK__GIT_STASHED_SYMBOL} {${stash_entry}}%{$reset_color%}"
  fi
}

# 0 repo is clean
# 1 repo has untracked files
# 2 repo is dirty
repo_status() {
    local result=0
    local repo_status=$(git status -s)
    if [[ -z "${repo_status}" ]]; then
        #
    else
        while read -r line; do
            #if [[ "${line:0:1}" == "?" || "${line:1:1}" == "?" ]]; then
            if [[ "${line:1:1}" == "?" ]]; then     # locally untracked
                result=$((result + 1))
                break
            fi
        done <<< "${repo_status}"

        while read -r line; do 
            #if [[ "${line:0:1}" == "M" || "${line:1:1}" == "M" ]]; then
            if [[ "${line:1:1}" == "M" ]]; then     # locally modified
                result=$((result + 2))
                break
            fi
        done <<< "${repo_status}"
    fi
    echo ${result}
}

# ---------------------------------------------
# The block itself

function blox_block__my_git() {

  if blox_block__git_helper__is_git_repo; then

    local commit_hash
    
    local repo_status=$(repo_status)
    local commit_color=$(set_commit_color ${repo_status})

    local branch_name="$(blox_block__git_helper__branch)"
    local branch_status="$(my_status  ${repo_status})"
    local stashed_status="$(my_stashed_status)"
    local remote_status="$(blox_block__git_helper__remote_status)"

    local result=""

    result+="%F{${BLOX_BLOCK__GIT_BRANCH_COLOR}}${branch_name}%{$reset_color%}"

    [[ $BLOX_BLOCK__GIT_COMMIT_SHOW != false ]] \
      && commit_hash="$(blox_block__git_helper__commit)" \
      && result+="%F{${commit_color}}${BLOX_CONF__BLOCK_PREFIX}${commit_hash}${BLOX_CONF__BLOCK_SUFFIX}%{$reset_color%}"

    result+="${branch_status}"
    result+="${stashed_status}"
    result+="${remote_status}"

    echo $result
  fi
}

BLOX_SEG__UPPER_LEFT=(user_host dir my_git)
BLOX_SEG__UPPER_RIGHT=(exec_time bgjobs time)
BLOX_SEG__LOWER_LEFT=(symbol)
