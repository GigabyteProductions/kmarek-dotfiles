#!/bin/bash -e

# create ~/.ssh before rcup would with incorrect permissions
test -d ~/.ssh || mkdir -v --mode 0700 ~/.ssh

# correct permissions on ssh configuration files before deployment

bindir="${BASH_SOURCE[0]%/*}"
bindir="${bindir:-/}"
test -n "${bindir%%/*}" && bindir="$PWD/$bindir"

basedir="$bindir/../.."

chmod -cR go-rwx "$basedir/ssh" "$basedir"/tag-*/ssh
