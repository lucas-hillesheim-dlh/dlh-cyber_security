#\!/bin/bash
ps -U "$1" u | grep -vE ' +0 +0 '
