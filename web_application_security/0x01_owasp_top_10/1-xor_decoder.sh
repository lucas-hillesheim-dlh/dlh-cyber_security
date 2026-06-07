#!/bin/bash
e=`echo -n ${1#\{xor\}} | base64 -d`
len=${#e}
i=0

while [ "$i" -lt "$len" ]
do
	char=$(($(printf %d "'${e:$i:1}") ^ 95))	
	printf \\$(printf '%03o' $char)
	i=$((i + 1))
done
