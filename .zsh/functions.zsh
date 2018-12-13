
function colors256() {
    for code ({000..255}) 
        print -P -- "$code: %F{$code} color%f"
}

function connect_HDMI(){
    if [[ "$#" -eq "0" ]]; then
        echo "output identifier is required"
        return 1
    else
        xrandr --output "$1" --auto --output eDP1 --auto --right-of "$1"
    fi
}

function disconnect_HDMI(){
    if [[ "$#" -eq "0" ]]; then
        echo "output identifier is required"
        return 1
    else
        xrandr --output "$1" --off
    fi
}

function info_VPN() {
    json=$(curl -u f0a5a396c73fd0: ipinfo.io -H 'Cache-Control: no-cache' 2>/dev/null)
    IP=$(echo ${json} | jq ".ip")
    LOC=$(echo ${json} | jq ".city")

    if [ "$1" -eq "1" ]; then
        printf "Public IP:\t %s\n" ${IP}
        printf "City:\t\t %s\n" ${LOC}
    fi

    if [ "$2" != "${IP}" ]; then
        return 0;
    else
        return 1;
    fi
}

#VPN_LOCATION="NEW-YORK"
VPN_LOCATION="LA"

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
        IP=$(curl -u f0a5a396c73fd0: ipinfo.io -H 'Cache-Control: no-cache' 2>/dev/null | jq ".ip")
        info_VPN 1
        echo ""
        echo "Connecting to VPN.."
        sudo openvpn --daemon --config ${HOME}/.torguard/torguard-PRO/TorGuard.USA-${VPN_LOCATION}.ovpn --cd ${HOME}/.torguard
        if [[ "$?" -eq "0" ]]; then
            echo "Checking connection.."
            sleep 1;
            info_VPN 0 ${IP}
            while [[ "$?" -eq "1" ]]; do
                echo "Checking connection.."
                sleep 1;
                info_VPN 0 "${IP}"
            done
            echo "Connection established"
            echo ""
            info_VPN 1
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
module="i2c_i801"

function fix_touchpad() {
    sudo modprobe -r ${module}
    sudo modprobe ${module}
}

if [ -n $commands[kubectl] ]; then
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
