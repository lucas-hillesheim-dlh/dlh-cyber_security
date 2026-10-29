#!/bin/bash
grep -o "Accepted password for root" audit.log | cut -d ' ' -f4 | uniq
