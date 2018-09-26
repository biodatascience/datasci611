
shakespeare.txt: 
	wget http://www.gutenberg.org/files/100/100-0.txt -o shakespeare.txt
	
thee_count_grep.txt: shakespeare.txt count_thee.sh 
	./count_thee.sh > thee_count_grep.txt
	
top_ten_grep.txt: shakespeare.txt count_b4_thee.sh
	./count_b4_thee.sh > top_ten_grep.txt
	
.PHONY: print_results
print_results: thee_count_grep.txt top_ten_grep.txt
	@echo "The word \"thee\" occurs" `cat thee_count_grep.txt` " times"
	@echo "The top ten most common words that precede \"thee\" are:"
	@cat top_ten_grep.txt
	
bar_plot.png: top_ten_grep.txt plot_top10.R
	Rscript plot_top10.R

.PHONY: all clear
all: print_results \
	 bar_plot.png

clear:
	rm -f project_fig.png

project_fig.png: clear
	make all -Bnd | ../makefile2graph/make2graph | dot -Tpng -o project_fig.png