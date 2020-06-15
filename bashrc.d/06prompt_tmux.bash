# prompt_tmux.bash

# If in a tmux or screen, use bright yellow
if [ \
  -n "$TMUX" \
  -o "$TERM" = "screen" -o "${TERMCAP/screen/}" != "$TERMCAP" \
  -o -n "$pstree_has_tmux" \
]; then
	PS1_UCOLOR="93"
	PS1_HCOLOR="93"
fi
