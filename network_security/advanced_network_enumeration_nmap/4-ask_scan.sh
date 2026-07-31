#!/bin/bash
sudo nmap -sA --reason --host-timeout 1000 -p $2 $1
