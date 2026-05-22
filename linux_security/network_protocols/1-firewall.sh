#!/bin/bash
iptables -A INPUT -j REJECT
iptables -A INPUT -p tcp --dport ssh -j ACCEPT
