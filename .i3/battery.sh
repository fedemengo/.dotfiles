#!/bin/bash

LIMIT=30
LOWER=20

while :
do
	BATTINFO=`acpi -b`
	PERCENTAGE=`echo $BATTINFO | cut -f 4 -d " " | sed -e 's/^\([0-9]*\)%,/\1/g'`
	if [[ `echo $BATTINFO | grep Discharging` && "$PERCENTAGE" -le "$LIMIT" ]]; then
		DISPLAY=:0.0; /usr/bin/notify-send "LOW BATTERY" "`echo $BATTINFO | awk -F',' '{print $2 " - " $3}'`" -u critical
	fi
	if [[ "$PERCENTAGE" -le "$LOWER" ]]; then
		sleep 1m
	else
		sleep 3m
	fi
done

