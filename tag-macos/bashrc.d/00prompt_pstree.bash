# prompt_pstree.bash

pid="$$"
while [ "$pid" -ne 0 ]; do
  # determine ppid and comm
  read -r ppid comm < <(ps o ppid=,comm= "$pid")

  # remove leading path
  comm="${comm##*/}"

  # are we ssh'd?
  if [ -z "${comm##sshd: *}" ]; then
    pstree_has_sshd=1
  fi

  # are we sudo'd?
  if [ -z "${comm/sudo/}" -o -z "${comm/su/}" ]; then
    pstree_has_sudo=1
  fi

  # are we tmux'd?
  if [ -z "${comm/tmux/}" -o -z "${comm/screen/}" ]; then
    pstree_has_tmux=1
  fi

  # next
  pid="$ppid"
done
