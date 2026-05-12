#!/bin/bash
sudo find $1 -perm -2000 -exec ls {} \; 2> /dev/null
