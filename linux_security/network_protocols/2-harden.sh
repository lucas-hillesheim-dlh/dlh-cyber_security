#!/bin/bash
find / -type d -perm -0002 -exec ls -d {} \; -exec chmod o-w -d {} \; 2> /dev/null
