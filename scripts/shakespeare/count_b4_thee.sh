# Find the top ten words that occur before the word "thee"

grep -Eio "\w+ thee" shakespeare_cw.txt | \
	cut -d ' ' -f 1 | \
	sort | \
	uniq -c | \
	sort -r | \
	head -10