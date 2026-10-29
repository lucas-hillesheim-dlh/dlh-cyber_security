#!/bin/bash
grep "new user" audit.log | cut -d '=' -f2 | cut -d ',' -f1 | sort | tr \\n ,
