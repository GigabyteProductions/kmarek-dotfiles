# .profile

# Source user specific startup files from ~/.profile.d/*.sh
nullglob="$(shopt -p nullglob)"
shopt -s nullglob
for i in ~/.profile.d/*.sh; do
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
