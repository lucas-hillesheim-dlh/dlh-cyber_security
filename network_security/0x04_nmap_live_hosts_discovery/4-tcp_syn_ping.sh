#!/bin/bash
sudo nmap -PS -p 22,80,443 $1
