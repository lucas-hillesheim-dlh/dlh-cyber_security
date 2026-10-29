#!/bin/bash
grep -E "iptables -A .+ ACCEPT" audit.log | wc -l
