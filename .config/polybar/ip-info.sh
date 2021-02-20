#!/bin/bash

file=$HOME/.config/polybar/info

info="$(curl -u ${IP_TOKEN}: ipinfo.io -H 'Cache-Control: no-cache' 2>/dev/null)"
data="$(echo "$info" | grep "ip\|city\|country\|timezone" | sed 's/\([" ,]\)//g')"

echo "IP Info" > $file

for l in $data; 
do 
    value=$(echo "$l" | cut -d':' -f2)
    printf "\n# %s" "$value"
done >> $file

#notify-send -u normal "`curl -u ${IP_TOKEN}: ipinfo.io -H 'Cache-Control: no-cache' 2>/dev/null | sed -n '2p;4,5p;7,8p' | sed 's/",/"/g;s/^\ *//g;s/\"//g' | awk 'BEGIN {print "IP Info"}; {split($0,v,":"); printf "%-8s\t\t%35s\n", v[1], v[2]}'`" -t 10000 &

notify-send -u normal "$(cat $file)" -t 10000 &
