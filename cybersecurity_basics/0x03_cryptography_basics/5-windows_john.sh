#!/bin/bash
john --format=NT --wordlist=/usr/share/wordlists/rockyou.txt $1 && john --show --format=NT hash.txt | grep ":" | awk -F':' '{print $2}' > 5-password.txt
