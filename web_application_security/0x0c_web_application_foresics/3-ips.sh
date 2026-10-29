#!/bin/bash
tail -n 35000 audit.log | grep "Failed password for invalid user" | grep -o -E "[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+" | sort -nu | wc
-l
