import re

# Parse pubmed search into separate files
# Make each file easier to parse in project 3.

digits_re = re.compile("^\d+\.\s")

def write_abstract_to_file(temp_lines, file_object):
	cat_line = ''
	passed_author_info = False
	abstract_present = False
	for tl in tmp_lines:
		if len(tl) > 1:
			cat_line += tl.strip()
		else:
			if len(cat_line) > 1:
				if passed_author_info and not abstract_present:
					abstract_present = len(cat_line) > 10
				rm_digits = digits_re.sub('', cat_line)
				outfile.write(rm_digits + '\n')
				if cat_line.find('Author information') > -1:
					passed_author_info = True
				cat_line = ''
	return abstract_present

# Main
with open('pubmed_result.txt', 'r', encoding='utf-8') as f:
	tmp_lines = []
	abs_cnt = 0
	for line in f:
		tmp_lines.append(line)
		if line.find('PMID') > -1:
			keep_file = False
			with open('abs{}.txt'.format(abs_cnt), 'w', encoding='utf-8') as outfile:
				keep_file = write_abstract_to_file(tmp_lines, outfile)
			tmp_lines = []
			if keep_file:
				abs_cnt += 1