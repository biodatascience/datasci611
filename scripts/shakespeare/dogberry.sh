# Extract all the quotes by the character DOGBERRY

grep -Ei -A 10 "[A-Z]{3,}" $1 |
	tr '\n\r' ' ' | \
	sed -E 's/([A-Z]{3,})/\n\1/g'  |
	grep -Ei "^DOGBERRY" > dogberry.txt
