# escape.bash

# TODO: handle LANG=C

# TODO: printf to variable
escape()
{
	local str=''

	local prefix=''
	local arg

	for arg in "$@"; do
		local e
		printf -v e '%q' "$arg"

		## if LANG=C but extended ASCII is present
		#if [ "$LANG" = "C" ] && [[ "$arg" =~ [^\xA8-\xFE] ]]; then
		#	# Note: as of writing (bash 5.0.17), this put single quotes around
		#	# numeric arguments.
		#	printf -v e '%s' "${arg@Q}"

		# doesn't need escaping
		elif [ "$arg" = "$e" ]; then
			#printf -v e '%s' "$arg"
			true

		# can be escaped with double-quotes
		# "str a b c"
		elif ! [[ "$arg" =~ [[:cntrl:]\$\`\"\\\!] ]]; then
			printf -v e '"%s"' "$arg"

		# can be escaped with single-quotes
		# 'str a "b" c'
		elif ! [[ "$arg" =~ [[:cntrl:]\'] ]]; then
			printf -v e "'%s'" "$arg"

		# can be escaped with double-quotes, escaping other double-quotes
		# "str 'a' \"b\" c"
		elif ! [[ "$arg" =~ [[:cntrl:]\$\`\\\!] ]]; then
			printf -v e '"%s"' "${arg//\"/\\\"}"

		# can be escaped with single-quotes, escaping other single-quotes
		# 'str '\''a'\'' "b" c'
		elif ! [[ "$arg" =~ [[:cntrl:]] ]]; then
			printf -v e "\'%s\'" "${arg//\'/\'\\\'\'}"

		# control character, use bash's %q escaping
		else
			#printf -v e '%s' "$e"
			true

		fi

		# add prefix and append
		printf -v e '%s%s' "$prefix" "$e"
		str+="$e"
		prefix=' '
	done

	echo "$str"
}
