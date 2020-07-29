# prompt_pstree.bash

# provide alternative to `readarray -d '' -t var` if bash is older than 4.4
#
# -d was introduced in 4.4
# See: https://lists.gnu.org/archive/html/info-gnu/2016-09/msg00012.html
#
# TODO: test for feature existence rather than version?
if [ "${BASH_VERSINFO[0]}" -gt 4 -o "${BASH_VERSINFO[0]}" -eq 4 -a "${BASH_VERSINFO[1]}" -ge 4 ]; then
  readarray_null()
  {
    readarray -d '' -t "$1"
  }
else
  readarray_null()
  {
    declare array="$1"
    eval "${array}=()"
    i=0
    while IFS= read -r -d '' elem; do
      eval "${array}[${i}]=$(printf %q "$elem")"
      i="$(($i+1))"
    done
  }
fi

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
  readarray_null cmdline < "/proc/$pid/cmdline"

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
