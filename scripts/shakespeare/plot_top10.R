library(tidyverse)

top10 = read_table('top_ten_grep.txt', col_names = c('count', 'word'), col_types = 'ic')

ggplot(top10, aes(x=reorder(factor(word), -count), y=count)) +
  geom_bar(stat='identity') +
  xlab('Word') +
  ylab('Count') +
  theme_bw()
 
ggsave('bar_plot.png', width=5, height=4)
