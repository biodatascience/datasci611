library(tidyverse)

# get data
results_df = read_csv('../data/iterate_results.csv')
tax_df = read_csv('../data/iterate_tax.csv', col_types = "cc")

# Plot mortality by week
results_df %>% 
  ggplot(aes(x=week, y=number_killed)) +
  geom_boxplot(aes(group=week))

# Actually, week 4 we had contamination problems with our 
# culture media. Throw out that week's results. They were 
# repeated in week 5.
results_df %>% 
  filter(week != 4) %>%
  ggplot(aes(x=week, y=number_killed)) +
  geom_boxplot(aes(group=week))

# Can we adjust mortality by dose? 
# Something like num_killed_per_od_unit
# Optical Density is a measure of culture
# turbidity (how much light is scattered ...
# i.e. how dense the cells have grown)
# of a bacterial culture
results2_df = results_df %>%
  filter(week != 4) %>%
  mutate(num_killed_per_od = number_killed / od)

results2_df %>%
  ggplot(aes(x=week, y=num_killed_per_od)) +
  geom_boxplot(aes(group=week))

# We need to take into account the diluted OD value 
# (OD is non-linear measure after ~1, so we replace with 
# OD of dilution and extrapolation)
results2_df = results_df %>%
  filter(week != 4) %>%
  mutate(adjusted_od = pmax(od, diluted_od, na.rm=TRUE),
         num_killed_per_od = number_killed / adjusted_od)

results2_df %>%
  ggplot(aes(x=week, y=num_killed_per_od)) +
  geom_boxplot(aes(group=week))

# Let's look at it by taxinomic group
# Join the tables and then plot
results3_df = results2_df %>% left_join(tax_df, by='id')

results3_df %>%
  ggplot(aes(x=taxonomy, y=num_killed_per_od, group=taxonomy)) +
  geom_violin(aes(group=taxonomy)) +
  geom_jitter(size=1.5, alpha=0.3) +
  theme(axis.text.x = element_text(angle=90))
