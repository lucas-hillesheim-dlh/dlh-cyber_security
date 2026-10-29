#!/bin/bash
grep "Failed password for invalid user" audit.log | grep -o -E "[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+" | sort -un | wc -l
