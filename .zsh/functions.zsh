
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

function connect_VPN() {
    PID=$(pgrep openvpn)
    if [ -n "$PID" ]; then
        echo "VPN already connected PID $PID"
        return 1
    else
        sudo openvpn --daemon --config ${HOME}/.torguard/torguard-PRO/TorGuard.USA-NEW-YORK.ovpn --cd ${HOME}/.torguard
    fi
}

function disconnect_VPN() {
    PID=$(pgrep openvpn)
    if [ -z "$PID" ]; then
        echo "No active VPN connections"
        return 1
    else
        echo "Closing connection..."
        sudo kill -9 $PID
    fi
}

function fix_touchpad() {
    sudo modprobe -r i2c_i801 
    sudo modprobe i2c_i801 
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

