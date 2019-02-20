# ssh_keys.bash

# A stupid alternative to ssh-copy-id
# (because ssh-copy-id has overcomplicated logic for detecting which keys
# are already installed, and I have non-local keys to install, too)

# ~/etc/ssh_keys.sh is piped to remote shell to install keys.
#
# Example script:
#
# #!/bin/sh -xe
# umask 0077
# test -d ~/.ssh/ || mkdir ~/.ssh/
# cat > ~/.ssh/authorized_keys << EOF
# # keys here
# EOF

# SYNOPSIS: ssh_keys destination
ssh_keys()
{
	ssh "$1" sh -xe < "$HOME/etc/ssh_keys.sh"
}
