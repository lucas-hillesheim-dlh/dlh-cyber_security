#!/bin/bash
whois -H $1 | awk '/^Admin|^Registrant|^Tech/{ sub(":",",");  print}' > $1.csv
