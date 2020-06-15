# prompt_root.bash

# use bold red for admin
if [ "$UID" -eq 0 ]; then
	PS1_UCOLOR="31;1"
fi
