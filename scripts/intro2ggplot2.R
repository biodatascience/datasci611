library(tidyverse)
library(RColorBrewer)

# Preview the data
diamonds
diamonds_subset = sample_n(diamonds, 1000, replace=FALSE)


# Bar charts are another example of a statistical transformation
# (like histograms). 
ggplot(diamonds_subset, aes(x=cut)) +
  geom_bar(aes(fill=cut))

# Create a custom color scale
?brewer.pal
myColors = brewer.pal(5,"BrBG") # produces an array/list of colors
names(myColors) = levels(diamonds_subset$cut) # converts to a named list

ggplot(diamonds_subset, aes(x=cut)) +
  geom_bar(aes(fill=cut)) +
  scale_fill_manual(values = myColors) # provides color scale for fill aesthetic

# https://www.w3schools.com/colors/colors_picker.asp


# Stacked bar charts are created by mapping a variable to the fill
# aesthetic
ggplot(diamonds_subset, aes(x=cut)) +
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


# Including another data set in a specific layer
df2 = tibble(x = c(1, 1, 1.5, 1.5, 2, 2, 2.5, 2.5), 
             y = c(1, 1.1, 1.1, 1.2, 1.2, 1.3, 1.3, 1.4),
             group = factor(rep(1, 8)))

ggplot(df, aes(x=x, y=y, group=group)) +
  geom_line(size=1.5, aes(color=group)) +
  geom_point(size=2) +
  geom_line(data=df2, aes(x=x, y=y, group=group))


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



# You can change the default axis limits
ggplot(df, aes(x=x, y=y, group=group)) +
  geom_line(size=1.5, aes(color=group)) +
  geom_point(size=2) +
  geom_hline(yintercept = 1.2, color='red', linetype='dashed') +
  geom_vline(xintercept = 2, color='blue', linetype='dashed') +
  xlim(1,2)


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


# You can include special fonts or symbols in your 
# titles and labels using the "expression" function
ggplot(diamonds, aes(x=cut)) +
  geom_bar() +
  labs(x='Diamond Type',
       y=expression(paste('Count'['diamond'])),
       title=expression(paste('Higher quality diamonds are most common'^{'usually'})))

ggplot(diamonds, aes(x=price)) +
  geom_histogram() +
  labs(x='Diamond Price ($)',
       y=expression(paste('Count'['diamond'])),
       title=expression(paste('Higher quality diamonds are most common ', lambda, ' ', pi)))


# Follow the link in the slides for more detailed examples, but to get started:
# paste() concatenates strings together
# [] = subscript
# ^{} = superscript
# special characters such as "lambda"