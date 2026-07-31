#!/bin/bash
sudo nmap -oN custom_scan.txt --scanflags URGACKPSHRSTSYNFIN -p $2 $1 2>&1>/dev/null
