#!/bin/bash
iptables -A INPUT -j REJECT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
