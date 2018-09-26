#!/usr/bin/env bash

# Find the top ten words that occur before the word "thee"

grep -Eio "\w+ thee" $1 | \
	cut -d ' ' -f 1 | \
	sort | \
	uniq -c | \
	sort -r | \
	head -10