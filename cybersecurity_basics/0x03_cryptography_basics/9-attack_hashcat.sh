#!/bin/bash
hashcat -m 0 -a 1 $1 wordlist1.txt wordlist2.txt && hashcat -m 0 -o 9-password.txt --outfile-format 2 --show $1
