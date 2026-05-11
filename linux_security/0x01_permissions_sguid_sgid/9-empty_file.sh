#!/bin/bash
sudo find $1 -size 0 -type f -empty -exec chmod 777 {} \; 2> /dev/null
