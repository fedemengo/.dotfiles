#!/bin/bash

HOME=${HOME:-"/home/fedemengo"}
TORGUARD="${HOME}/.config/torguard"
VPN_LOC=${VPN_LOCATION:-"USA-SF"}
PID=$(pgrep openvpn)
PASS=$(cat ${TORGUARD}/__pwwd)

if [ -n "$PID" ]; then
    notify-send -u critical "Disconnecting VPN"
    for ps in `pgrep openvpn`;
    do
        echo ${PASS} | sudo -S kill -9 ${ps}
    done
else
    notify-send -u low "Connecting to VPN"
    echo ${PASS} | sudo -S openvpn --daemon --config ${TORGUARD}/torguard-PRO/TorGuard.${VPN_LOC}.ovpn --cd ${TORGUARD}
fi

