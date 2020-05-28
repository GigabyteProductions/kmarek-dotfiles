# .bash_logout

# Source user specific aliases and functions from ~/.bash_logout.d/*.bash
nullglob="$(shopt -p nullglob)"
shopt -s nullglob
for i in ~/.bash_logout.d/*.bash; do
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
