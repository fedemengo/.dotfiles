#!/bin/bash

HOME="/home/fedemengo"
TORGUARD="${HOME}/.config/torguard"
VPN_LOC=${VPN_LOCATION:-"USA-SF"}
PID=$(pgrep openvpn)
PASS=$(cat ${TORGUARD}/__pwwd)

touch $HOME/fuck

if [ -n "$PID" ]; then
    for ps in `pgrep openvpn`;
    do
        sudo kill -9 ${ps} 2>&1
    done
fi

sudo openvpn --daemon --config ${TORGUARD}/torguard-PRO/TorGuard.${VPN_LOC}.ovpn --cd ${TORGUARD}
