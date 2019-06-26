#!/bin/bash

millis=$(echo "$(date +%N) / 1000000" | bc)
filename="$(date +%a-%b-%d-%y-@%H:%M:%S.)${millis}"
read -p "Save session to ${HOME}./sessions/${filename}? [y/n] " res
case $res in
    [Yy]* ) exec terminator -e "script '${HOME}/.sessions/${filename}'"; break;;
    [Nn]* ) exec terminator; break;;
esac

