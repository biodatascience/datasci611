# Extract all the quotes by the character DOGBERRY

grep -Ei -A 10 "DOGBERRY" shakespeare_cw.txt |
	tr '\n\r' ' ' | \
	sed 's/DOGBERRY/\nDOGBERRY/g' > dogberry_partial.txt
	