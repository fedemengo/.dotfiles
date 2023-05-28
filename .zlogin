if [ -z "$SSH_AUTH_SOCK" ] ; then
	eval `ssh-agent -s` &> /dev/null
	find ${HOME}/.ssh/ -not -name "*.pub" -type f | xargs ssh-add &> /dev/null
fi

# this should be the last command as exec replace the current process
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then 
	  exec startx &>/dev/null 
fi

