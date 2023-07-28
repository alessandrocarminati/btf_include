#!/bin/sh
for i in $(find -L /lib/modules/$(uname -r)/build/ -type f | grep "\.[hcS]$"); do 
	grep -P "^[ \t]*(struct|union)[ \t]+[^\t ]+[ \t]*{" $i |sed -r 's/^[ \t]*((struct|union)[ \t]+[^\t ]+)[ \t]*\{.*/\1/'| sed -e 's/  */ /g'; 
	done
