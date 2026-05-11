#!/bin/bash
sudo find $1 -perm /6000 -mtime 0 -exec ls -ldb {} \; 2> /dev/null
