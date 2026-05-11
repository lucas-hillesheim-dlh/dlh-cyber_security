#!/bin/bash
sudo find $1 -perm /6000 -type f -mtime -1 -exec ls -ldb {} \; 2> /dev/null
