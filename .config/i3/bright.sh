#!/bin/bash

bright=`xbacklight -get`

if [[ `echo "${bright} > 0.0" | bc` == "1" ]]; then
    echo "${bright}" > ${HOME}/.config/i3/__brightness_level
    xbacklight -set 0
else
    level=`cat ${HOME}/.config/i3/__brightness_level 2>/dev/null`
    xbacklight -set ${level:-75}
fi

