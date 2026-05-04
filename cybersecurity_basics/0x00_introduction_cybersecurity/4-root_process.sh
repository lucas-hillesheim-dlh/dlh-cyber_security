#\!/bin/bash
ps --no-headers -U $1 -u $1 u | grep -vE ' +0 +0 '
