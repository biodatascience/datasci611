library(ggplot2)
library(dplyr)

# Preview the data
diamonds
diamonds_subset = sample_n(diamonds, 1000, replace=FALSE)

# To start, assign variables to the x and y axes, 
# and pick a geom (here I chose scatter plot or "geom_point")
ggplot(diamonds_subset,aes(x=carat, y=price)) +
  geom_point()


# Take a moment to learn some Rstudio features:
# - "CTRL + Enter" to run selected code (or "Run" button above)
# - Environment tab to view data
# - Console vs editor
# - Plot, Files, Packages and Help tabs
# - ?function to access help


# Examples of other geoms
# Notice that these ones include a statistical transform
ggplot(diamonds_subset, aes(x=carat, y=price)) +
  geom_hex()



ggplot(diamonds_subset, aes(x=carat, y=price)) +
  geom_bin2d()



# It's easy to add layers ... just tack on another "geom"
# Take a moment to explore all the possible geom layers
ggplot(diamonds_subset,aes(x=carat, y=price)) +
  geom_point() +
  geom_rug(alpha=0.3)



ggplot(diamonds_subset,aes(x=carat, y=price)) +
  geom_point() +
  geom_smooth()



# To modify the appearance of the elements of a layer, 
# add specifications for size, alpha (transparency), etc.
ggplot(diamonds_subset,aes(x=carat, y=price)) +
  geom_point(size=4, color='red') +
  geom_smooth()



ggplot(diamonds_subset,aes(x=carat, y=price)) +
  geom_point(size=4, alpha=0.2) +
  geom_smooth(size=3)



# To link the appearance of the elements of a layer to 
# variables in the data, use the same specifications as above
# but define the dependency in an "aes" section
ggplot(diamonds_subset,aes(x=carat, y=price)) +
  geom_point(size=4, aes(shape=cut)) +
  geom_smooth() +
  theme_bw()



ggplot(diamonds_subset,aes(x=carat, y=price)) +
  geom_point(size=4, aes(color=cut, shape=color)) +
  geom_smooth()



# Facets are another way to map variables onto your visualization
ggplot(diamonds_subset,aes(x=carat, y=price)) +
  geom_point(size=4) +
  facet_wrap(~cut)



# Statistical transformations incorporate summaries of your data 
# easily into your visualization
ggplot(diamonds_subset,aes(x=price)) +
  geom_histogram()



ggplot(diamonds_subset,aes(x=cut, y=price)) +
  geom_boxplot()



# Labels make your axes interpretable
ggplot(diamonds_subset,aes(x=price)) +
  geom_histogram() +
  xlab('Price in US Dollars') +
  ylab('Count') +
  ggtitle('Distribution of Diamond Prices')



# OR
ggplot(diamonds_subset,aes(x=price)) +
  geom_histogram() +
  labs(x='Price in US Dollars',
       y='Count',
       title='Distribution of Diamond Prices')



# And finally, to save a figure as a file
ggsave('outfile.png', height=3, width=5)
