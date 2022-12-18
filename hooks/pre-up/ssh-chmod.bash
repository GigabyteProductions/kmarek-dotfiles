#!/bin/bash

# hooks/pre-up/ssh-chmod.bash

# This hook removes write permission granted to group or other from ssh
# config file mode.
#
# Background:
#
# ssh (and sshd when StrictModes is yes) prohibit the use of config
# files with modes that are too permissive. However, git only keeps
# track of file executabiliy [*]. So if there is no post-checkout git
# hook configured to correct mode, git will checkout ssh config files
# according to the umask of the user and indexed executability.
#
# [*]: Git tree objects actually record a POSIX-style 3-digit octal
#      mode. However, at the time of writing, only "755" and "644" are
#      valid for regular files [1]. In fact, you may notice that write
#      permission for group and other are not even set in the git tree.
#
# [1]: https://git.kernel.org/pub/scm/git/git.git/plain/Documentation/technical/index-format.txt?h=v2.33.0

set -e
shopt -s nullglob

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

# dir_candidates are the places ssh configs may exist
# (nullglob prevents the unmatched globs from causing problems)
dir_candidates=(
	"$basedir"/ssh
	"$basedir"/tag-*/ssh
	"$basedir"/host-*/ssh
)

# dirs are the directories that exist
dirs=()
for dir in "${dir_candidates[@]}"; do
	if [ -d "$dir" ]; then
		dirs+=("$dir")
	fi
done

# correct permissions on ssh configuration files before deployment
# by calling chmod if any ssh config directories were found
if [ "${#dirs[@]}" -gt 0 ]; then
	chmod -cR go-w -- "${dirs[@]}"
fi
