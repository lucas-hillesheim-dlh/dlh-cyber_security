#!/bin/bash
grep -E '^[^#]*security' /etc/postfix/main.cf || echo "STARTTLS not configured"
