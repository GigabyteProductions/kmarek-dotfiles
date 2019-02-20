# history.bash
# Note: optionally depends on debug.bash

# store unlimited history in ~/.bash_history.archive
# (using a separate file so things like `bash --norc` doesn't murder)
HISTFILE=~/.bash_history.archive
HISTFILESIZE="" # unlimited

# but only load last 1000 commands for immediate use
HISTSIZE="1000"

# timestamp commands
HISTTIMEFORMAT="%F %T: "

# Allow sensitive commands to be omitted by prefixing with a space
# (also clobbers existing HISTCONTROL value to remove a common default of
# ignoredups so repeat occurrences will still be timestamped)
HISTCONTROL="ignorespace"

# Make sure commands make it to $HISTFILE before they even start executing
DEBUG_COMMAND="history -a; $DEBUG_COMMAND"

# but if DEBUG trap was clobbered, do the next best alternative and run
# after each command
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# Convenience function to grep $HISTFILE
histgrep()
{
	grep "$@" "$HISTFILE"
}
