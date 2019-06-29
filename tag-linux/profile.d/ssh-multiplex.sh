# ssh-multiplex.sh

# For use with ssh_config option:
# ControlPath /var/run/user/%i/ssh/controlmasters/%C
#
# Ensures ControlPath directory exists
mkdir --mode 0700 -p "/var/run/user/$UID/ssh/controlmasters/"
