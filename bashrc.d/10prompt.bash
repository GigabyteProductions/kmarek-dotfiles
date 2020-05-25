# prompt.bash

# Default to green
PS1_UCOLOR="${PS1_UCOLOR:-32}"
PS1_HCOLOR="${PS1_HCOLOR:-32}"

# generate prompt from PS1_UCOLOR and PS1_HCOLOR
reprompt()
{
	PS1="\\[\\e[0m\\]\\n\\[\\e[${PS1_UCOLOR:-33;1}m\\]\\u\\[\\e[0;${PS1_HCOLOR:-33;1}m\\]@\\H\\[\\e[0m\\] \\[\\e[0;33m\\]\\w\\[\\e[0m\\]\\n\\$ "
}

reprompt
