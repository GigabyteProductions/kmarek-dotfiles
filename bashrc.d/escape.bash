# escape.bash

escape()
{
	local str=''

	local prefix=''
	local arg

	for arg in "$@"; do
		local e
		printf -v e '%s%q' "$prefix" "$arg"
		prefix=' '
		str+="$e"
	done

	echo "$str"
}
