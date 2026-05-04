#\!/bin/bash
ps h -u $1 u | grep -v "0     0"
