#!/bin/bash
nmap --script 'ssl-enum-ciphers' $1
