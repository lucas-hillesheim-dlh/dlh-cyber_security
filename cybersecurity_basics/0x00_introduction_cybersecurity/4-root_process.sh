#\!/bin/bash
ps --no-headers -U "$1" u | grep -v "  *0  *0 "
