#!/usr/bin/env python3
import socket

def check_port(host, port):
    """Check if a port is open"""
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(1)
        result = sock.connect_ex((host, port))
        sock.close()
        return result == 0
    except (socket.gaierror,TimeoutError):
        return False

if __name__ == "__main__":
    import sys
    host = sys.argv[1]
    port = sys.argv[2]
    print(check_port(host, port))

