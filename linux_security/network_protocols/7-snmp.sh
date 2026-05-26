#!/bin/bash
find /etc/snmp/ -name "snmpd.conf" -exec grep -E "^[^#]*public" {} +
