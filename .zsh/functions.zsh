
function colors256() {
    for code ({000..255}) 
        print -P -- "$code: %F{$code} color%f"
}

function restart_polybar() {
    sh ${HOME}/.config/polybar/launch.sh 1>/dev/null
}

function connect_HDMI(){
    position=left
    if [[ "$#" -eq "0" ]]; then
        echo "output identifier is required"
        return 1
    else
        if [[ "$#" -eq "2" ]]; then
            position="$2"
        fi
		pos=""
		if [[ "$position" == "left" ]]; then
			pos="right"
		else
			pos="left"
		fi

        xrandr --output "$1" --set audio on --auto --output eDP1 --auto --${pos}-of "$1"
        restart_polybar
    fi
}

function disconnect_HDMI(){
    if [[ "$#" -eq "0" ]]; then
        echo "output identifier is required"
        return 1
    else
        xrandr --output "$1" --off
        restart_polybar
    fi
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

#module="psmouse"

function fix_touchpad() {
    module=${MODULE:-"i2c_i801"}
    sudo modprobe -r ${module}
    sudo modprobe ${module}
}

if [ -n "$commands[kubectl]" ]; then
    source <(kubectl completion zsh)
fi

if [ -z ${SSH_AUTH_SOCK} ]; then
    eval `ssh-agent -s` &> /dev/null
    find ${HOME}/.ssh/ -not -name "*.pub" -type f | xargs ssh-add &> /dev/null
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

if [ -n "$commands[todo.sh]" ]; then
    title=$(todo.sh ls | tail -n 1)
    todos=$(todo.sh ls | head -n $(($(todo.sh ls | wc -l)-2)) | sort)
    #echo "$(tput setaf 197)$title $(tput sgr0)\n$todos\n"
fi
