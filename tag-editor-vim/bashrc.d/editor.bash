# editor.bash

# remove any existing command "overrides"
# so bash will only find executables in $PATH
unalias vi >/dev/null 2>&1
unset vi
unalias vim >/dev/null 2>&1
unset vim
unalias vimx >/dev/null 2>&1
unset vimx

# default to vi, which should be on every modern unix system OOTB
export EDITOR=vi

# use vim if it exists
if command -v vim >/dev/null 2>&1; then
export EDITOR=vim
alias vi=vim
fi

# use vimx if it exists
if command -v vimx >/dev/null 2>&1; then
export EDITOR=vimx
alias vim=vimx
alias vi=vim
fi
