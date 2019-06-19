
police_data.tsv:
	curl -o police_data.tsv https://raw.githubusercontent.com/fivethirtyeight/data/master/police-locals/police-locals.csv

police_plot.png: police_data.tsv make_police_plot.R
	Rscript make_police_plot.R

.PHONY: clean project_fig.png
clean:
	rm -f project_fig.png police_plot.png police_data.tsv

project_fig.png:
	make police_plot.png -Bnd | ../../../makefile2graph/make2graph | dot -Tpng -o project_fig.png
