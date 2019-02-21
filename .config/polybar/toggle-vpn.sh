#!/bin/bash

VPN_LOCATION="LA"
PID=$(pgrep openvpn)
PASS=`cat ${HOME}/.config/polybar/__pwwd`

if [ -n "$PID" ]; then
    notify-send -u critical "Disconnecting VPN"
    for ps in `pgrep openvpn`;
    do
        echo ${PASS} | sudo -S kill -9 ${ps}
    done
else
    notify-send -u low "Connecting to VPN"
    echo ${PASS} | sudo -S openvpn --daemon --config ${HOME}/.torguard/torguard-PRO/TorGuard.USA-${VPN_LOCATION}.ovpn --cd ${HOME}/.torguard
fi

