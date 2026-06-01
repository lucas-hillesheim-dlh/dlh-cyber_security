#!/bin/bash
sudo nmap -sn -PS -p 22,80,443 $1
