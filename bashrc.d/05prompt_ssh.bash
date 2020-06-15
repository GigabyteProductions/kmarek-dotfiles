# prompt_ssh.bash

# If in an ssh session, use bright magenta
if [ -n "$SSH_CONNECTION" -o -n "$pstree_has_sshd" ]; then
	PS1_UCOLOR="95"
	PS1_HCOLOR="95"
fi
