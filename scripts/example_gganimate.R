library(tidyverse)
library(gganimate)

atb = tibble(t = rep(1:5, 2), 
             a = c((1:5)/10, (5:1)/10), 
             b = c('A','A','A','A','A','B','B','B','B','B'))

ggplot(atb, aes(x=factor(b), y=a)) + 
  geom_point() +
  labs(title = 'State {closest_state}') +
  transition_states(states = b, transition_length = 1, state_length = 1) +
  #labs(title = 'time {frame_time}') +
  #transition_time(time = t) +
  ease_aes('linear')
