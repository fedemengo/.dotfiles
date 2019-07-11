#!/bin/bash

touch "/home/fedemengo/$(/usr/bin/pgrep openvpn)"

killall -9 openvpn;

openvpn --config /home/fedemengo/.config/torguard/torguard-PRO/TorGuard.USA-SF.ovpn --cd /home/fedemengo/.config/torguard/
