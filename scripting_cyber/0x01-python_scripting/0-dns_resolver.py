#!/usr/bin/env python3
import socket
import sys

def resolve_domain_to_ipv4(domain):
    try:
        result = socket.gethostbyname(domain)
    except socket.gaierror as e:
        result = ""
    return result

if __name__ == "__main__":
    domain = socket.argv[1]
    resolve_domain_to_ipv4(domain)
