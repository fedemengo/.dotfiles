#!/bin/bash

ssh_connections=$(who | grep -c "pts")
no_suspend_file="/etc/no-suspend"

# Block suspend if any tmux pane runs something other than an interactive shell
tmux_busy=0
if pgrep -x tmux >/dev/null; then
    busy_panes=$(tmux list-panes -a -F "#{pane_current_command}" 2>/dev/null \
        | grep -vE '^(bash|zsh|fish|sh)$' \
        | wc -l)
    if [ "$busy_panes" -gt 0 ]; then
        tmux_busy=1
    fi
fi

if [ $ssh_connections -eq 0 ] && [ ! -f "$no_suspend_file" ] && [ $tmux_busy -eq 0 ]; then
    systemctl suspend
else
    if [ $ssh_connections -gt 0 ]; then
        echo "Active SSH connections found. Not suspending."
    elif [ -f "$no_suspend_file" ]; then
        echo "No-suspend file exists. Not suspending."
    elif [ $tmux_busy -gt 0 ]; then
        echo "tmux has running program. Not suspending."
    fi
fi

