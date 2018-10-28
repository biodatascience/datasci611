

with open('pubmed_result.txt', 'r', encoding='utf-8') as f:
	tmp_lines = []
	abs_cnt = 0
	for line in f:
		tmp_lines.append(line)
		if line.find('PMID') > -1:
			with open('abs{}.txt'.format(abs_cnt), 'w', encoding='utf-8') as outfile:
				for tl in tmp_lines:
					outfile.write(tl)
			tmp_lines = []
			abs_cnt += 1