#!/usr/bin/env bash

# Find the top ten words that occur before the word "thee"

cat $1 | grep -Eio "\w+ thee" | \
	cut -d ' ' -f 1 | \
	sort | \
	uniq -c | \
	sort -nr | \
	head -10
