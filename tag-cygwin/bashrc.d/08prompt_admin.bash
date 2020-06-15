# prompt_admin.bash

# use bold red for admin
# See: https://sourceware.org/legacy-ml/cygwin/2015-02/msg00057.html
# See: https://web.archive.org/web/20200525224428/https://sourceware.org/legacy-ml/cygwin/2015-02/msg00057.html
if [[ "$(id -G)" =~ (^|[[:space:]])544([[:space:]]|$) ]]; then
	PS1_UCOLOR="31;1"
fi
