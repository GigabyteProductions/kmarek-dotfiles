# urlescape.bash
# See: https://gist.github.com/cdown/1163649

urlencode() {
	# urlencode <string>

	local LANG=C
	local str=''
	local i length="${#1}"
	for (( i = 0; i < length; i++ )); do
		local c="${1:i:1}"
		local e
		case $c in
			[a-zA-Z0-9.~_-]) printf -v e "%s" "$c" ;;
			*) printf -v e '%%%02X' "'$c" ;;
		esac
		str+="$e"
	done

	echo "$str"
}

urldecode() {
	# urldecode <string>

	local url_encoded="${1//+/ }"
	printf '%b' "${url_encoded//%/\\x}"
}
