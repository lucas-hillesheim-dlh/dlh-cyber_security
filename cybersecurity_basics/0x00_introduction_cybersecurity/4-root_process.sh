#\!/bin/bash
ps --no-headers -u $1 u | grep -v "0     0"
