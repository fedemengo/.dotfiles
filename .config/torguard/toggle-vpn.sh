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
	#remote1=$(cat ${TORGUARD}/torguard-PRO/TorGuard.${VPN_LOC}.ovpn | grep remote -m1 | cut -d' ' -f2-)
	#remote2=$(cat ${TORGUARD}/torguard-PRO/TorGuard.${VPN_LOC}.ovpn | grep remote -m1 | tail -n1 | cut -d' ' -f2-)
	echo $PASS | sudo -S openvpn --remote "${remote1}" tcp-client --remote ${remote2} tcp-client --compress --ping 5 --ping-restart 30 --connect-timeout 30 --nobind --dev tun --cipher AES-256-GCM --auth SHA256 --auth-nocache --tls-auth "${HOME}/.cert/nm-openvpn/TorGuard.${VPN_LOC}-tls-auth.pem" 1 --remote-cert-tls server --reneg-sec 0 --verb 1 --syslog nm-openvpn --tun-mtu 1500 --mssfix 1450 --script-security 2 --up /usr/lib/nm-openvpn-service-openvpn-helper --debug 0 305978 --bus-name org.freedesktop.NetworkManager.openvpn.Connection_74 --tun -- --up-restart --persist-key --persist-tun --management /var/run/NetworkManager/nm-openvpn-8e90efaa-5eba-4023-bc22-2a5b7081191d unix --management-client-user root --management-client-group root --management-query-passwords --auth-retry interact --route-noexec --ifconfig-noexec --client --auth-user-pass --ca "${HOME}/.cert/nm-openvpn/TorGuard.${VPN_LOC}-ca.pem" --user nm-openvpn --group nm-openvpn
    #echo ${PASS} | sudo -S openvpn --daemon --config ${TORGUARD}/torguard-PRO/TorGuard.${VPN_LOC}.ovpn --cd ${TORGUARD}
fi

