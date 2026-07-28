#!/bin/bash
curl $2 -H "HOST: $1" -d "$3"
