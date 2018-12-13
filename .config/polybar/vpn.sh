#!/bin/bash

PID=$(pgrep openvpn)
json=$(curl -u f0a5a396c73fd0: ipinfo.io -H 'Cache-Control: no-cache' 2>/dev/null) 
LOC=$(echo ${json} | jq ".city")

if [ -n "$PID" ]; then
    echo "on (${LOC//\"/})"
else
    echo "off"
fi

