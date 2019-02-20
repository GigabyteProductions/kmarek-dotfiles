# prompt.bash

# Use green
PS1_COLOR="32"

# If in an ssh session, use bright magenta
if [ -n "$SSH_CONNECTION" ]; then
	PS1_COLOR="95"
fi

# Prompt with color defaulting to bold red if PS1_COLOR was unset
PS1='\[\e[0m\]\n\[\e[${PS1_COLOR:-31;1}m\]\u@\H \[\e[0;33m\]\w\[\e[0m\]\n\$ '

# Export PS1 to carry over sudo
export PS1
