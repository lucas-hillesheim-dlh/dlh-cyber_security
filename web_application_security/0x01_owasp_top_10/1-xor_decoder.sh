#!/bin/bash
echo "$1" | sed 's/^{xor}//' | base64 -d | perl -pe 's/(.)/$1 ^ "_"/ge'
