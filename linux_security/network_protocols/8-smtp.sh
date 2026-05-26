#!/bin/bash
postconf -n smtpd_tls_security_level || echo "STARTTLS not configured"
