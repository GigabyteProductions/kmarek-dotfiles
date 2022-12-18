#!/bin/bash

# hooks/pre-up/ssh-chmod.bash

set -e

# create ~/.ssh before rcup would with incorrect permissions
test -d ~/.ssh || mkdir -v --mode 0700 ~/.ssh

# correct permissions on ssh configuration files before deployment

bindir="${BASH_SOURCE[0]%/*}"
bindir="${bindir:-/}"
test -n "${bindir%%/*}" && bindir="$PWD/$bindir"

# find the root of this dotfiles repository relative to this hook
# (this hook is in hooks/pre-up/)
basedir="$bindir/../.."

chmod -cR go-rwx "$basedir/ssh" "$basedir"/tag-*/ssh
