#!/usr/bin/sh

#./auto-hide

spawn() {
    (MONITOR="$1" polybar i3bar &>/dev/null) & disown
}

source ${HOME}/.config/polybar/polybar-env.sh

# Terminate and wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do killall -q polybar; sleep 0.3; done

echo "Launching main screen"

# set latop monitor as primary
spawn "eDP1"

echo "Launching other screens" && \

# Launch bar1 for other monitors
for monitor in `polybar -m | cut -d: -f1`;
do
    if [[ "${monitor}" != "eDP1" ]]; then
        spawn "${monitor}"
        #(MONITOR=${monitor} polybar i3bar &
        #MONITOR=${monitor} polybar i3bar -c ~/.config/polybar/config &
    fi
done

echo "Bars launched..."

