#!/bin/bash
ps huU "$1" | grep -v "  *0  *0 "
