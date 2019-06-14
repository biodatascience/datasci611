
shakespeare.txt:
	curl -o shakespeare.txt http://www.gutenberg.org/files/100/100-0.txt

top_ten_grep.txt: shakespeare.txt count_b4_thee.sh
	./count_b4_thee.sh shakespeare.txt > top_ten_grep.txt

bar_plot.png: top_ten_grep.txt plot_top10.R
	Rscript plot_top10.R

.PHONY: clean project_fig.png
clean:
	rm -f project_fig.png bar_plot.png shakespeare.txt

project_fig.png:
	make bar_plot.png -Bnd | ../../../makefile2graph/make2graph | dot -Tpng -o project_fig.png
