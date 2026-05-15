#!/bin/bash
hashcat -m 0 --outfile-format 2 -o 7-password.txt $1 /usr/share/wordlists/rockyou.txt
