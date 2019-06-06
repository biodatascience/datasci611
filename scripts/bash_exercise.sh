#!/usr/bin/env bash

curl $1 -o downloaded_file.csv

cat downloaded_file.csv | awk '{print $1}' | sed 's/e/3/g' > output.txt
