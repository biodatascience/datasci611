library(tidyverse)

# Read in the data
police_df = read_csv(url("https://raw.githubusercontent.com/fivethirtyeight/data/master/police-locals/police-locals.csv"),
                     na = "**")

## Pipe
# Find the cities where the police force contains more than 4000 officers,
# sort by "all" variable, the select the top 5 rows
large_force = police_df %>%
  filter(police_force_size > 4000) %>%
  arrange(all) %>%
  head()
large_force

# Find the cities where the police force contains less than 4000 officers,
# create a new variable "w.nw.ratio", sort by the new variable, then
# select the last 5 rows
small_force = police_df %>%
  mutate(w.nw.ratio = white / `non-white`) %>%
  arrange(w.nw.ratio) %>%
  tail()
small_force

## Gathering
# Move rates "white" and "black" to a new pair of columns 
# called "w.b.rates" (contains what used to be column names) and
# called "rate.val" (contains rate values)
gathered_df = police_df %>% 
  gather(white, black, key='w.b.rates', value='rate.val')
gathered_df

ggplot(gathered_df, aes(x=w.b.rates, y=rate.val)) +
  geom_violin(aes(fill=w.b.rates)) + 
  geom_jitter(alpha=0.5, size=2)

## Spreading
# Restore gathered_df to look like police_df
spread_df = gathered_df %>% 
  spread(key='w.b.rates', value='rate.val')
spread_df

## Joining
