if [ -n "$SSH_AUTH_SOCK" ] ; then
	eval `ssh-agent -k` &> /dev/null
fi
