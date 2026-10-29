#!/bin/bash
grep -oE "new user: name=[^,]+" audit.log | sed 's/.*name=//' | LC_ALL=C sort | paste -sd,
