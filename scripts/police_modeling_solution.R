library(tidyverse)
library(reshape2)

# Download and format data
police_df = read_csv(url('https://raw.githubusercontent.com/fivethirtyeight/data/master/police-locals/police-locals.csv'))

police_df = police_df %>%
  melt(id=c('city', 'police_force_size')) %>%
  mutate(fraction=as.numeric(value))

# Plot data
ggplot(police_df, aes(x=police_force_size, y=fraction, group=variable)) +
  geom_point(aes(color = variable))

# Build model
mod1 = lm(fraction ~ police_force_size * variable, data=police_df)

# Plot model predictions
predictions = police_df %>%
  data_grid(police_force_size, variable) %>%
  gather_predictions(mod1)

ggplot(police_df, aes(x=police_force_size, y=fraction, group=variable)) +
  geom_point(aes(color = variable)) +
  geom_line(data=predictions, aes(y=pred, color=variable)) +
  facet_wrap(~variable)
