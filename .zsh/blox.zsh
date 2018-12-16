
ZSH_THEME="blox-zsh-theme/blox"

# Define some colors
LIGHT_GREEN=76
LIGHT_BLUE=38

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
            fi
        fi
    done
    output+="%{$reset_color%}"
    echo ${output}
}

function blox_block__vcs() {
    
}

BLOX_SEG__UPPER_LEFT=(user_host dir git)
BLOX_SEG__UPPER_RIGHT=(exec_time bgjobs time)
BLOX_SEG__LOWER_LEFT=(symbol)
