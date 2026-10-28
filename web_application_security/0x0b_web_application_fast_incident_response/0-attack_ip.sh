#!/bin/bash
grep -o -E "[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+" logs.txt | sort -n | uniq -c | sort -n | tail -n 1 | cut -d ' ' -f5
