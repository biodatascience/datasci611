# Import tidyverse
library(tidyverse)

# Read in data
congress = read.csv('datasci611_src/data/congress-terms.csv', sep=',', header=TRUE, 
                    colClasses=c('integer','factor','character','character','character','character','character','Date','character','factor','factor','Date','numeric'))
congress_t = as_tibble(congress)

librarians = read.csv('datasci611_src/data/librarians-by-msa.csv', sep=',', header=TRUE, na.strings='**', 
                      colClasses=c('character','character','numeric','numeric','numeric','numeric'))
librarians_t = as_tibble(librarians)

# Limit congress to most recent congress (113th)
recent_congress =  congress_t %>%
  filter(congress == max(congress_t$congress))

librarians_ave = librarians_t %>% 
  rename(state = prim_state) %>%
  group_by(state) %>%
  summarise(ave_jobs_1000 = mean(jobs_1000))

# Join the two tables
congress_librarians = inner_join(recent_congress, librarians_ave, by='state' )

# Plot
ggplot(data = congress_librarians, mapping = aes(x=age, y=ave_jobs_1000, color=party)) +
  geom_point() +
  scale_color_manual(values=c("blue","green","red")) +
  ggtitle('figure1') +
  theme_bw()

ggplot(data = congress_librarians, mapping = aes(x=party, y=ave_jobs_1000)) +
  geom_boxplot(size=1) +
  geom_jitter(alpha=0.5, mapping = aes(color=party)) +
  scale_color_manual(values=c("blue","green","red")) +
  ggtitle('figure2') +
  theme_bw()


# Test null-hypothesis that distributions are the same
ave_jobs_D = congress_librarians %>%
  filter(party == 'D') %>%
  select(ave_jobs_1000)

ave_jobs_R = congress_librarians %>%
  filter(party == 'R') %>%
  select(ave_jobs_1000)

wt = wilcox.test(ave_jobs_R$ave_jobs_1000,ave_jobs_D$ave_jobs_1000)
wt$p.value
