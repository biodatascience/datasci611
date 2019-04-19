library(tidyverse)
library(nycflights13)


## Gather "dep_delay" and "arr_delay" into a variable "delay"
# Use mutate to log transform the delay values, then
# pipe directly into ggplot and display as a box plot
flights %>%
  gather(dep_delay, arr_delay, key='delay', value='delay.val') %>%
  mutate(l.delay.val = log2(delay.val)) %>%
  ggplot(aes(x=delay, y=l.delay.val)) + 
    geom_boxplot(aes(fill=delay))

## Identify the airlines that experienced the most precipitation
# Joint flights to weather by year, month, day, hour, and origin
# Filter for cases where precipitation was greater than 90th percentile
# (hint: use quantile() function
# Select the carrier variable and count the number of occurences of each
# carrier with flights under high precipitation conditions
# 
# Do the same carrier counting, but without the filter (on the flights dataframe)
# Join the two results and use mutate to calculate a ratio between the 
# number of high precipitation flights and the total number of flights
# Join with the "airlines" dataframe to get the full names of the airlines
#
# Which airlines see the most precipitation?
# Which see the most as a proportion of their flights?
precip_df = flights %>%
  left_join(weather, by=c('year', 'month', 'day', 'hour', 'origin')) %>%
  filter(precip > quantile(precip, 0.9, na.rm=TRUE)) %>%
  select(carrier) %>%
  count(carrier) %>%
  arrange(-n) %>%
  mutate(w.cnt = n)

all_flight_counts = flights %>%
  select(carrier) %>%
  count(carrier) %>%
  mutate(a.cnt = n)

ratio_weather = precip_df %>%
  left_join(all_flight_counts, by='carrier') %>%
  mutate(ratio = w.cnt / a.cnt) %>%
  left_join(airlines, by='carrier') %>%
  select(name, w.cnt, a.cnt, ratio)
ratio_weather %>% arrange(-w.cnt)
ratio_weather %>% arrange(-ratio)
