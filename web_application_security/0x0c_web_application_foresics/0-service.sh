#!/bin/bash
cat audit.log | tr -s ' ' | cut -d ' ' -f6 | sort | uniq -c | sort -rn
