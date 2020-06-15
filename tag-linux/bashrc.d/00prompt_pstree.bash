# prompt_pstree.bash

pid="$$"
while [ "$pid" -ne 0 ]; do
  # determine ppid
  ppid=""
  while IFS=$'\t' read -r key value; do
    if [ "${key%:}" = "PPid" ]; then
      ppid="$value"
    fi
  done < /proc/"$pid"/status

  # determine cmdline
  readarray -d '' -t cmdline < "/proc/$pid/cmdline"

  # determine comm
  IFS=$'' read -r comm < "/proc/$pid/comm"

  # are we ssh'd?
  if [ -z "${comm/sshd/}" ]; then
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
  test -n "$ppid" || break
  pid="$ppid"
done
