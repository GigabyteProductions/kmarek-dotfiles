# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Source user specific aliases and functions from ~/.bashrc.d/*.bash
nullglob="$(shopt -p nullglob)"
shopt -s nullglob
for i in ~/.bashrc.d/*.bash; do
	if [ -r "$i" ]; then
		if [ "${-#*i}" != "$-" ]; then
			. "$i"
		else
			. "$i" >/dev/null
		fi
	fi
done
eval "$nullglob"
unset nullglob
