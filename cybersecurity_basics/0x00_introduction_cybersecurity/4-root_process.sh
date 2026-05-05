#!/bin/bash
ps huU "$1" | grep -vE "\s+0\s+0\s"
