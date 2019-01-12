
ZSH_THEME="blox-zsh-theme/blox"

# Define some colors
LIGHT_GREEN=76
LIGHT_BLUE=39
GREEN=2
YELLOW=11
ORANGE=202

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
BLOX_BLOCK__GIT_COMMIT_COLOR="gray"
BLOX_BLOCK__GIT_STASHED_COLOR="gray"

BLOX_BLOCK__DIR_COLOR=${LIGHT_BLUE}
BLOX_BLOCK__DIR_LEN=3


function blox_block__my_user_host() {
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

function blox_block__my_dir() {
    local LEN=${BLOX_BLOCK__DIR_LEN}
    local output="%F{${BLOX_BLOCK__DIR_COLOR}}"

    DIR=${PWD//${HOME}/\~}
    if [[ "${PWD}" != "${HOME}"* ]]; then
        output+="/"
        DIR=${PWD}
    fi

    DIRS=(${(s:/:)${DIR}})
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
                output+=$(echo -n "/${dir}" | sed "s/.\{$n\}$//g")
                output+=$(echo -n -e "\U2026")
            # or use the name if already short enough
            else
                output+=$(echo -n "/${dir}")
            fi
        fi
    done
    output+="%{$reset_color%}"
    echo ${output}
}

# ---------------------------------------------
# Git block options

# Commit hash
BLOX_BLOCK__GIT_COMMIT_SHOW="${BLOX_BLOCK__GIT_COMMIT_SHOW:-true}"

# Clean
BLOX_BLOCK__GIT_CLEAN_COLOR="${BLOX_BLOCK__GIT_CLEAN_COLOR:-green}"
BLOX_BLOCK__GIT_CLEAN_SYMBOL="${BLOX_BLOCK__GIT_CLEAN_SYMBOL:-✔}"

# Dirty
BLOX_BLOCK__GIT_DIRTY_COLOR=${YELLOW}
BLOX_BLOCK__GIT_DIRTY_SYMBOL="!"
BLOX_BLOCK__GIT_DIRTY_COLOR="${BLOX_BLOCK__GIT_DIRTY_COLOR:-yellow}"
BLOX_BLOCK__GIT_DIRTY_SYMBOL="${BLOX_BLOCK__GIT_DIRTY_SYMBOL:-!}"

# Untracked
BLOX_BLOCK__GIT_UNTRACKED_COLOR="${BLOX_BLOCK__GIT_UNTRACKED_COLOR:-red}"
BLOX_BLOCK__GIT_UNTRACKED_SYMBOL="${BLOX_BLOCK__GIT_UNTRACKED_SYMBOL:-?}"

BLOX_BLOCK__GIT_UNPUSHED_COLOR=${LIGHT_BLUE}
BLOX_BLOCK__GIT_UNPULLED_COLOR=${ORANGE}

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
    local st=$1
    local color=${BLOX_BLOCK__GIT_CLEAN_COLOR}
    (((st & 1) == 1)) && color=${BLOX_BLOCK__GIT_UNTRACKED_COLOR}
    (((st & 2) == 2)) && color=${BLOX_BLOCK__GIT_DIRTY_COLOR}
    echo "${color}"
}

# Echo the appropriate symbol for branch's status
function my_status() {
    local st=$1
    if [[ -z "$1" ]]; then
        echo " $BLOX_BLOCK__GIT_THEME_CLEAN"
    else
        (((st & 2) == 2)) && echo -n " $BLOX_BLOCK__GIT_THEME_DIRTY"
        (((st & 1) == 1)) && echo -n " $BLOX_BLOCK__GIT_THEME_UNTRACKED"
    fi
}

# Echo the appropriate symbol if there are stashed files
function my_stashed_status() {
  if $(command git rev-parse --verify refs/stash &> /dev/null); then
    local stash_entry=$(command git stash list | wc -l)
    echo " %F{${BLOX_BLOCK__GIT_STASHED_COLOR}]%}${stash_entry}${BLOX_BLOCK__GIT_STASHED_SYMBOL}%{$reset_color%} "
  fi
}

# 0 repo is clean
# 1 repo has untracked files
# 2 repo is dirty
function my_repo_status() {
    local result=0
    local st=$(git status -s)
    if [[ -n "${st}" ]]; then
        while read -r line; do
            #if [[ "${line:0:1}" == "?" || "${line:1:1}" == "?" ]]; then
            if [[ "${line:1:1}" == "?" ]]; then     # locally untracked
                result=$((result + 1))
                break
            fi
        done <<< "${st}"

        while read -r line; do 
            if [[ "${line:0:1}" == "M" || "${line:1:1}" == "M" ]]; then
            #if [[ "${line:1:1}" == "M" ]]; then     # locally modified
                result=$((result + 2))
                break
            fi
        done <<< "${st}"
    fi
    echo ${result}
}


# Echo the appropriate symbol for branch's remote status (pull/push)
# Need to do 'git fetch' before
function my_remote_status() {
    local branch=$(command git branch | grep "*" | cut -d ' ' -f 2)
    local git_local=$(command git rev-parse @ 2> /dev/null)
    local git_remote=$(command git rev-parse ${branch}@{u} 2> /dev/null)
    local git_base=$(command git merge-base @ @{u} 2> /dev/null)

    local unpulled=$(git rev-list --count HEAD..origin/${branch} 2>/dev/null)
    [[ "${unpulled}" -eq "0" ]] && unpulled=""

    local unpushed=$(git rev-list --count origin/${branch}..HEAD 2>/dev/null)
    [[ "${unpushed}" -eq "0" ]]  && unpushed=""

    # First check that we have a remote
    if ! [[ ${git_remote} = "" ]]; then
        if [[ ${git_local} = ${git_remote} ]]; then
            echo ""
        elif [[ ${git_local} = ${git_base} ]]; then
            echo " %F{${BLOX_BLOCK__GIT_UNPULLED_COLOR}]%}${unpulled}$BLOX_BLOCK__GIT_UNPULLED_SYMBOL%{$reset_color%}"
        elif [[ ${git_remote} = ${git_base} ]]; then
            echo " %F{${BLOX_BLOCK__GIT_UNPUSHED_COLOR}]%}${unpushed}$BLOX_BLOCK__GIT_UNPUSHED_SYMBOL%{$reset_color%}"
        else
            echo " %F{${BLOX_BLOCK__GIT_UNPULLED_COLOR}]%}${unpulled}$BLOX_BLOCK__GIT_UNPULLED_SYMBOL%{$reset_color%}  %F{${BLOX_BLOCK__GIT_UNPUSHED_COLOR}]%}${unpushed}$BLOX_BLOCK__GIT_UNPUSHED_SYMBOL%{$reset_color%}"
        fi
    fi
}

# ---------------------------------------------
# The block itself

function blox_block__my_git() {

  if blox_block__git_helper__is_git_repo; then

    local commit_hash
    
    local st=$(my_repo_status)
    local commit_color=$(set_commit_color ${st})

    local branch_name="$(blox_block__git_helper__branch)"
    local branch_status="$(my_status  ${st})"
    local stashed_status="$(my_stashed_status)"
    local remote_status="$(my_remote_status)"

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

BLOX_SEG__UPPER_LEFT=(my_user_host my_dir my_git)
BLOX_SEG__UPPER_RIGHT=(exec_time bgjobs time)
BLOX_SEG__LOWER_LEFT=(symbol)

