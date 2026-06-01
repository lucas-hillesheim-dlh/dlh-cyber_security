#!/usr/bin/env python3
from socket import gethostbyname, gaierror
from sys import argv

def resolve_domain_to_ipv4(domain):
    try:
        result = gethostbyname(domain)
    except gaierror as e:
        result = ""
    return result

if __name__ == "__main__":
    domain = argv[1]
    resolve_domain_to_ipv4(domain)
