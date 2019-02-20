# debug.bash

# If DEBUG_COMMAND is set, the value will be executed as a command in
# trapping DEBUG.
#
# This is to mimic the builtin PROMPT_COMMAND behavior, by allowing
# sourced .bashrc.d files to independently trap DEBUB and avoid clobbering
# existing traps by adding to the value of DEBUG_COMMAND.
_debug_hooks() {
	eval $DEBUG_COMMAND
}

trap _debug_hooks DEBUG
