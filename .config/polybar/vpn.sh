#!/bin/bash

PID=$(pgrep openvpn)

wg show > /dev/null
r=$?

if [ -n "$PID" ]; then
    echo "openvpn"
elif [ "$r" -eq 1 ]; then
	# wireguard
	echo "wg"
else
    echo "off"
fi

