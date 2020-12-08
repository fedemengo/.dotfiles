#!/bin/bash

notify-send -u normal "`curl -u ${IP_TOKEN}: ipinfo.io -H 'Cache-Control: no-cache' 2>/dev/null | sed -n '2p;4,5p;7,8p' | sed 's/",/"/g;s/^\ *//g;s/\"//g' | awk 'BEGIN {print "IP Info"}; {split($0,v,":"); printf "%-8s\t\t%35s\n", v[1], v[2]}'`" -t 10000 &

