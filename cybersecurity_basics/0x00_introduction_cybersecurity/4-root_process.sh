#!/bin/bash
ps ps huU $1 | grep -v "  *0  *0 "
