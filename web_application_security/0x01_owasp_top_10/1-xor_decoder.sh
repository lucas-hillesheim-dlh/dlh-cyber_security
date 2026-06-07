#!/bin/bash
e=`echo $1 | cut -c 6- | base64 -d`
for (( i=0; i<${#e}; i++));
do
	char=$(($(printf %d "'${e:$i:1}") ^ 95))	
	printf \\$(printf '%03o' $char)
done
