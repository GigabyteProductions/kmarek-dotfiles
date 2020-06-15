# prompt_pstree.bash

pid="$$"
while [ "$pid" -ne 1 ]; do
  # determine ppid
  ppid=""
  while IFS=$'\t' read -r key value; do
    if [ "${key%:}" = "PPid" ]; then
      ppid="$value"
    fi
  done < /proc/"$pid"/status

  # determine cmdline
  readarray -d '' -t cmdline < "/proc/$pid/cmdline"

  # remove leading path
  cmdline[0]="${cmdline[0]##*/}"

  # are we ssh'd?
  if [ -z "${cmdline[0]/sshd/}" ]; then
    pstree_has_sshd=1
  fi

  # are we sudo'd?
  if [ -z "${cmdline[0]/sudo/}" -o -z "${cmdline[0]/su/}" ]; then
    pstree_has_sudo=1
  fi

  # are we tmux'd?
  if [ -z "${cmdline[0]/tmux/}" -o -z "${cmdline[0]/screen/}" ]; then
    pstree_has_tmux=1
  fi

  # next
  test -n "$ppid" || break
  test -d "/proc/$ppid" || break
  pid="$ppid"
done
