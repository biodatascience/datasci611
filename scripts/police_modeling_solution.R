library(tidyverse)
library(reshape2)
library(modelr)

# Download and format data
police_df = read_csv(url('https://raw.githubusercontent.com/fivethirtyeight/data/master/police-locals/police-locals.csv'),
                     na='**')

police_df = police_df %>%
  gather(-city, -police_force_size, key='variable', value='value') 

# Plot data
ggplot(police_df, aes(x=police_force_size, y=value, group=variable)) +
  geom_point(aes(color = variable))

# Build model
mod1 = lm(value ~ police_force_size * variable, data=police_df)

# Plot model predictions
predictions = police_df %>%
  data_grid(police_force_size, variable) %>%
  gather_predictions(mod1)

ggplot(police_df, aes(x=police_force_size, y=value, group=variable)) +
  geom_point(aes(color = variable)) +
  geom_line(data=predictions, aes(y=pred, color=variable)) +
  facet_wrap(~variable)
