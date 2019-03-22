library(ggplot2)
library(tidyverse)

# ggplot creates a plot object when called.
# You can add to the plot object repeatedly 
p = ggplot(diamonds, aes(x=cut, y=price)) 
p = p + geom_jitter(alpha=0.2)
p = p + geom_violin(alpha=0.4, aes(color=cut))
print(p)

# Bar charts are another example of a statistical transformation
# (like histograms). 
ggplot(diamonds, aes(x=cut)) +
  geom_bar()

# Stacked bar charts are as simple as mapping a variable to the fill
# aesthetic
ggplot(diamonds, aes(x=cut)) +
  geom_bar(aes(fill=color))

# To connect lines, you need to group points
df = tibble(x = c(1,2,3,4,1,2,3,4,1,2,3,4), 
            y = c(1.1,1.2,1.3,1.4,1.4,1.3,1.2,1.1,1,1.3,1,1.3),
            group = factor(c(1,1,1,1,2,2,2,2,3,3,3,3)))

df

ggplot(df, aes(x=x, y=y, group=group)) +
  geom_point()

ggplot(df, aes(x=x, y=y, group=group)) +
  geom_line(size=1.5, aes(color=group)) +
  geom_point(size=2)

# Annotations can be added using an "annotation" layer
# https://ggplot2.tidyverse.org/reference/annotate.html
ggplot(df, aes(x=x, y=y, group=group)) +
  geom_line(size=1.5, aes(color=group)) +
  geom_point(size=2) +
  annotate("text", x = 2.5, y = 1.2, label = "Great lines", size=15)

ggplot(df, aes(x=x, y=y, group=group)) +
  geom_line(size=1.5, aes(color=group)) +
  geom_point(size=2) +
  geom_hline(yintercept = 1.2, color='red', linetype='dashed') +
  geom_vline(xintercept = 2, color='blue', linetype='dashed')

# The classic ggplot theme isn't bad, but often it's good to 
# have simpler backgrounds and plot structure
ggplot(df, aes(x=x, y=y, group=group)) +
  geom_line(size=1.5, aes(color=group)) +
  geom_point(size=2) +
  geom_hline(yintercept = 1.2, color='red', linetype='dashed') +
  geom_vline(xintercept = 2, color='blue', linetype='dashed') +
  theme_minimal()

# More generally, any characteristic of a figure can be changed 
# using the theme layer
ggplot(df, aes(x=x, y=y, group=group)) +
  geom_line(size=1.5, aes(color=group)) +
  geom_point(size=2) +
  geom_hline(yintercept = 1.2, color='red', linetype='dashed') +
  geom_vline(xintercept = 2, color='blue', linetype='dashed') +
  theme_light() +
  theme(legend.position = "none", 
        axis.ticks.length = unit(2, "cm"))


