#!/bin/bash
find /etc/snmp/snmpd.conf -name "snmpd.conf" -exec grep -E "^[^#]*public" {} +
