#!/bin/bash

# https://andi-siess.de/rgb-to-color-temperature/

gamma=$(xrandr --verbose | grep eDP1 -A4 | grep Gamma | cut -d: -f2,3,4 | tr -s ' ')

gm="1.0:1.0:1.0"
echo .${gamma}.
if [[ "$gamma" == *"$gm" ]];
then
	gmma="1:0.71:0.42"
	brg="0.7"
else
	gmma="1:1:1"
	brg="1"
fi

for disp in $(xrandr | grep " connected" | cut -d' ' -f1);
do
	xrandr --output $disp --gamma "$gmma" --brightness "$brg"
done

