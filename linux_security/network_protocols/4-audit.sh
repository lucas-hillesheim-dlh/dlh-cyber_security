#!/bin/bash
sudo grep -Ev '^[[:space:]]*#' /etc/ssh/sshd_config | grep -Ev '^[[:space:]]*$'
