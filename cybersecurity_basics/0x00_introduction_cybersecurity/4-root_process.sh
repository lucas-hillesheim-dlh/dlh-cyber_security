#\!/bin/bash
ps --no-headers -U $1 -u $1 u | grep -v -E '^[^ \t]+[ \t]+[^ \t]+[ \t]+[^ \t]+[ \t]+[^ \t]+[ \t]+[0 \t]*0'
