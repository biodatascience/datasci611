library(tidyverse)

# Download and format data
police_df = read_csv(url('https://raw.githubusercontent.com/fivethirtyeight/data/master/police-locals/police-locals.csv'))

ggplot(police_df %>% filter(police_force_size > 1000), aes(police_force_size, all)) +
  geom_point()

ggsave('police_plot.png')
