
function open() {
    if [[ "$OS" == "Darwin" ]]; then
        command open "$@"
    elif command -v xdg-open >/dev/null 2>&1; then
        xdg-open "$@"
    else
        echo "open: no suitable opener found (tried open, xdg-open)" >&2
        return 1
    fi
}

function colors256() {
    for code ({000..255})
        print -P -- "$code: %F{$code} color%f"
}


function myip() {
    json=$(curl -u ${IP_TOKEN}: ipinfo.io -H 'Cache-Control: no-cache' 2>/dev/null)
    IP=$(echo ${json} | jq ".ip")
    LOC=$(echo ${json} | jq ".city")

    if [[ "$#" -lt "1" ]]; then
        printf "Public IP:\t %s\n" ${IP}
        printf "City:\t\t %s\n" ${LOC}
    fi

    if [ "$1" != "${IP}" ]; then
        return 0;
    else
        return 1;
    fi
}

# # if no socket, init agent
# if [ -z "$SSH_AUTH_SOCK" ]; then
#     AGENT_FILE="$HOME/.ssh-agent"
#     if [ -f "$AGENT_FILE" ]; then
#         source "$AGENT_FILE" > /dev/null
#         if ! ps -p $SSH_AGENT_PID > /dev/null; then
#             ssh-agent -s > "$AGENT_FILE" & disown | xargs -I {} echo "SSH agent started with PID: {}" >> $ZSH_SOURCING_LOG_FILE
#             source "$AGENT_FILE"
#         fi
#     else
#         ssh-agent -s > "$AGENT_FILE" & disown | xargs -I {} echo "SSH agent started with PID: {}" >> $ZSH_SOURCING_LOG_FILE
#         source "$AGENT_FILE"
#     fi
#     find $HOME/.ssh/ -not -name "*.pub" -type f \
#         -not -name config \
#         -not -name known_hosts \
#         -not -name authorized_keys | xargs ssh-add >> $ZSH_SOURCING_LOG_FILE
# fi

sock="$HOME/.ssh/agent.sock"
# If SSH forwarded a real agent, update the stable symlink to point at it
if [[ -S "$SSH_AUTH_SOCK" && "$SSH_AUTH_SOCK" != "$sock" ]]; then
    ln -sf "$SSH_AUTH_SOCK" "$sock"
elif [ ! -S "$sock" ]; then
    # No forwarded agent and no existing socket — start a local one
    eval "$(ssh-agent -s)" > /dev/null
    ln -sf "$SSH_AUTH_SOCK" "$sock"
    find "$HOME/.ssh" -type f \
        -not -name "*.pub" \
        -not -name "config" \
        -not -name "known_hosts" \
        -not -name "authorized_keys" \
        | xargs ssh-add >/dev/null 2>&1
fi
export SSH_AUTH_SOCK="$sock"


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
      *.zip)       unzip $1 -d ${1/%.zip/}     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

function stop_prune() {
	docker container stop $(docker container ps -aq)
	docker container prune
}

function zat() {
	zathura "$@" 2>/dev/null 1>&2 & disown
}

function zshaddhistory() {
	echo "${1%%$'\n'}|${PWD}   " >> ~/.zsh_history_ext
}

function jog() {
    grep -v "jog" ~/.zsh_history_ext | grep -a --color=never "${PWD}   " | cut -f1 -d"|" | tail | fzf
}

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

function forward-kill-word {
    zle forward-word
    zle backward-kill-word
}

function pacman-util {
	com="sudo pacman -S"
	BUFFER="${com}${BUFFER}"
	CURSOR=${#BUFFER}
}

function yay-util {
	com="yay -S"
	BUFFER="${com}${BUFFER}"
	CURSOR=${#BUFFER}
}

function sudo-util {
	com="sudo "
	BUFFER="${com}${BUFFER}"
	CURSOR=${#BUFFER}
}

function redo-sudo {
    #cmd=$(history | tail -1 | cut -d' ' -f4-)
	cmd=$(cat ~/.zsh_history | tail -1 | cut -d';' -f2)
	BUFFER="sudo ${cmd}"
	CURSOR=${#BUFFER}
	#sudo $cmd
}

function get_pod {
    kubectl get pods | rg "$1" | head -1 | tr -s "" | cut -d' ' -f1
}

function pod_env {
    POD=$(get_pod $1)
    echo "retrieving env from pod $POD"
    kubectl exec -it $POD -- env
}

function pod_env_prefix {
    POD=$(get_pod $1)
    echo "retrieving env from pod $POD"
    kubectl exec -it $POD -- env | rg "$2"
}


