#!/bin/bash

PID=$(pgrep openvpn)

if [ -n "$PID" ]; then
    echo "on"
else
    echo "off"
fi

