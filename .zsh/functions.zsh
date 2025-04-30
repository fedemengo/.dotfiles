
function colors256() {
    for code ({000..255})
        print -P -- "$code: %F{$code} color%f"
}


function info_VPN() {
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

# Before connecting to vpn, change DNS resulution
# - In file /etc/resolv.conf add 1.1.1.1 and google's 8.8.8.8
# - Make the file inmutable with "sudo chattr +i /etc/resolv.conf"
# Done

function connect_VPN() {
    PID=$(pgrep openvpn)
    if [ -n "$PID" ]; then
        echo "VPN already connected PID $PID"
        return 1
    else
        # Get sudo access
        sudo ls &>/dev/null
        echo "Current location"
        IP=$(curl -u ${IP_TOKEN}: ipinfo.io -H 'Cache-Control: no-cache' 2>/dev/null | jq ".ip")
        info_VPN
        echo ""
        echo "Connecting to VPN.."
        sudo openvpn --daemon --config ${HOME}/.torguard/torguard-PRO/TorGuard.USA-${VPN_LOCATION}.ovpn --cd ${HOME}/.torguard
        if [[ "$?" -eq "0" ]]; then
            echo "Checking connection.."
            sleep 1;
            info_VPN ${IP}
            while [[ "$?" -eq "1" ]]; do
                echo "Checking connection.."
                sleep 1;
                info_VPN ${IP}
            done
            echo "Connection established"
            echo ""
            info_VPN
        else
            RET=$?
            echo "Impossible to connect to VPN"
            return ${RET}
        fi
    fi
}

function disconnect_VPN() {
    PID=$(pgrep openvpn)
    if [ -z "$PID" ]; then
        echo "No active VPN connections"
        return 1
    else
        echo "Closing connection..."
        for ps in `pgrep openvpn`;
        do
            sudo kill -9 ${ps}
        done
    fi
}

if [ -n "$commands[kubectl]" ]; then
    source <(kubectl completion zsh)
    alias k=kubectl
    alias kubectl=kubecolor
    compdef kubecolor=kubectl
fi

# if no socket, init agent
if [ -z "$SSH_AUTH_SOCK" ]; then
    AGENT_FILE="$HOME/.ssh-agent"
    if [ -f "$AGENT_FILE" ]; then
        source "$AGENT_FILE" > /dev/null
        if ! ps -p $SSH_AGENT_PID > /dev/null; then
            ssh-agent -s > "$AGENT_FILE" & disown | xargs -I {} echo "SSH agent started with PID: {}" >> $ZSH_SOURCING_LOG_FILE
            source "$AGENT_FILE"
        fi
    else
        ssh-agent -s > "$AGENT_FILE" & disown | xargs -I {} echo "SSH agent started with PID: {}" >> $ZSH_SOURCING_LOG_FILE
        source "$AGENT_FILE"
    fi
    find $HOME/.ssh/ -not -name "*.pub" -type f \
        -not -name config \
        -not -name known_hosts \
        -not -name authorized_keys | xargs ssh-add >> $ZSH_SOURCING_LOG_FILE
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
      *.zip)       unzip $1 -d ${1/%.zip/}     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

function mc() {
	name="${1%%.*}"
	mcs $1 && mono "${name}.exe"
}

function dns() {
	sudo chattr -i /etc/resolv.conf && sudo vim /etc/resolv.conf && sudo chattr +i /etc/resolv.conf
}

function vpns() {
	for conf in ${HOME}/.torguard/torguard-PRO/*;
	do
		echo $conf | sed "s|$HOME/.torguard/torguard-PRO/TorGuard.||;s|.ovpn||g"
	done
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

function home {
	data="${HOME:=/home/fedemengo}"
	BUFFER="${BUFFER}${data}/"
	CURSOR=${#BUFFER}
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


