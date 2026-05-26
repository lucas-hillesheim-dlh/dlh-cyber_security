#!/bin/bash
sudo grep -v '^[[:space:]]*#' /etc/ssh/sshd_config | grep -v '^[[:space:]]*$'
