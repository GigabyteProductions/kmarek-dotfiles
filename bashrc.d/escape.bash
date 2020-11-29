# escape.bash

# TODO: handle LANG=C

escape()
{
	local str=''

	local prefix=''
	local arg

	for arg in "$@"; do
		local e
		printf -v e '%q' "$arg"

		# if LANG=C but extended ASCII is present
		if [ "$LANG" = "C" ] && [[ "$arg" =~ [^\xA8-\xFE] ]]; then
			e="${prefix}${arg@Q}"

		# doesn't need escaping
		elif [ "$arg" = "$e" ]; then
			printf -v e '%s%s' "$prefix" "$arg"

		# can be escaped with double-quotes
		# "str a b c"
		elif ! [[ "$arg" =~ [[:cntrl:]\$\`\"\\\!] ]]; then
			printf -v e '%s"%s"' "$prefix" "$arg"

		# can be escaped with single-quotes
		# 'str a "b" c'
		elif ! [[ "$arg" =~ [[:cntrl:]\'] ]]; then
			printf -v e "%s'%s'" "$prefix" "$arg"

		# can be escaped with double-quotes, escaping other double-quotes
		# "str 'a' \"b\" c"
		elif ! [[ "$arg" =~ [[:cntrl:]\$\`\\\!] ]]; then
			printf -v e '%s"%s"' "$prefix" "${arg//\"/\\\"}"

		# can be escaped with single-quotes, escaping other single-quotes
		# 'str '\''a'\'' "b" c'
		elif ! [[ "$arg" =~ [[:cntrl:]] ]]; then
			printf -v e "%s\'%s\'" "$prefix" "${arg//\'/\'\\\'\'}"

		fi
		prefix=' '
		str+="$e"
	done

	echo "$str"
}
