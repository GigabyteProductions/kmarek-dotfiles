#!/bin/bash

# hooks/pre-up/ssh-chmod.bash

set -e

# correct permissions on ssh configuration files before deployment

bindir="${BASH_SOURCE[0]%/*}"
bindir="${bindir:-/}"
test -n "${bindir%%/*}" && bindir="$PWD/$bindir"

# Add g=w,o=w to the current umask (removing these bits from new files)
umask="$(umask)"
umask="$(printf '%03o' "$((8#$umask | 8#022))")"
umask "$umask";

# precreate_candidates are the directories that may need to be created
precreate_candidates=(
	~/.ssh
	~/.ssh/config.d
)

# precreate are the directories that do not exist yet
precreate=()
for dir in "${precreate_candidates[@]}"; do
	if [ ! -d "$dir" ]; then
		precreate+=("$dir")
	fi
done

# pre-create directories that require restrictive permissions
# (umask restricts the mode, avoiding an extra call to chmod)
if [ "${#precreate[@]}" -gt 0 ]; then
	mkdir -v -- "${precreate[@]}"
fi

# find the root of this dotfiles repository relative to this hook
# (this hook is in hooks/pre-up/)
basedir="$bindir/../.."

chmod -cR go-rwx "$basedir/ssh" "$basedir"/tag-*/ssh
