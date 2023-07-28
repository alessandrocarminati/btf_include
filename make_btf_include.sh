#!/bin/bash

declare -A visited

queue=()

extract_structure() {
#	echo "visiting  --$1-- ${#queue[@]}" >&2
	pahole linuximage |  grep -zoP "${1}\s*\{(?:[^{}]+|\{[^{}]*\})*\}" | sed 's/\x0/;\n/g'
}

is_struct_item() {
	echo "${1}" | grep -qP "^[ \t]+(struct|union)[ \t]+[^\t ]+[ \t\*]+[^\t ]+[ \t]*;"
}

is_already_used() {
	echo "${visited[${1}]}" | grep -vq "yes"
}

string2visit() {
	echo "$1" | sed -r "s/^[ \t]+((struct|union)[ \t]+[^ ]+).*;.*/\1/"
}

visit_structure() {
	if echo "${visited[${1}]}" | grep -vq "yes"; then
		queue+=("${1}");
		visited[${1}]="yes"
		while read -r item; do
			is_struct_item "$item" && is_already_used $item && visit_structure $(string2visit $item)
			done < <(extract_structure ${1})
		fi
}

[ $# -ne 1 ] && exit 1
STRUCT_REGEX="^[ \t]+(struct|union)[ \t\*]+[^\t ]+[ \t]+[^\t ]+[ \t]*;"

IFS=`printf '\n'`
for i in `grep "BTF_INCLUDE" $1`; do
	echo $i | grep -qE "^[ \t]*(.*) [^ \t]+)[ \t]*;.*BTF_INCLUDE.*$";
	TO_EXTRACT=`echo $i | sed -r  's/^[ \t]*(.*) [^ \t]+[ \t]*;.*BTF_INCLUDE.*$/\1/'`;
	visit_structure $TO_EXTRACT;
	done

echo "Explaration finished, producing header ${#queue[@]}" >&2
#echo "//${#queue[@]} imported from BTF"
while ! [ ${#queue[@]} -eq 0 ]; do
	top=${#queue[@]}
	top=$((top - 1))
	item="${queue[$top]}"
	unset "queue[$top]"
	! grep -q "$item" in_headers.db &&extract_structure $item
done
exit 0
