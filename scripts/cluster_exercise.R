library(tidyverse)
library(mclust)

police_df = read_csv(url('https://raw.githubusercontent.com/fivethirtyeight/data/master/police-locals/police-locals.csv'), na = '**')

#-------------------------
# Determine an appropriate 
# number of clusters for the
# data
#-------------------------
kmeans_wss <- Vectorize(function(c){
  tmp_wss = police_df %>%
    select(all, white, `non-white`) %>%
    kmeans(centers=c)
  return(sum(tmp_wss$withinss))
})

cluster_fit = tibble(num_centers=1:15) %>%
  mutate(wss = kmeans_wss(num_centers))

ggplot(cluster_fit, aes(num_centers, wss)) +
  geom_point() +
  geom_line() +
  labs(x="Number of Clusters",
       y="Within groups sum of squares") 

#-------------------------
# Assign clusters using 
# K-means
#-------------------------
fit = police_df %>%
  select(all, white, `non-white`) %>%
  kmeans(3) 

# Append cluster assignment
police_df$cluster = as.factor(fit$cluster)

# Plot results
ggplot(police_df, aes(`non-white`, white, group=cluster)) +
  geom_label(aes(label=city, fill=cluster))

#-------------------------
# Assign clusters using 
# HAC
#-------------------------
# Calculate distance between all observations
dist_mat = police_df %>%
  select(all, white, `non-white`) %>%
  dist(method = "euclidean") 

# Cluster closest first, then work outwards
hfit = hclust(dist_mat, method="average") 
plot(hfit) 

# Append cluster assignment
groups = cutree(hfit, k=3) 
police_df$cluster_h = as.factor(groups)

rect.hclust(hfit, k=3, border="red")

# Plot results
ggplot(police_df, aes(`non-white`, white, group=cluster_h)) +
  geom_label(aes(label=city, fill=cluster_h))

#-------------------------
# Assign clusters using 
# EM Algorithm
#-------------------------
em_fit = police_df %>%
  select(all, white, `non-white`) %>%
  Mclust(G=3)

# Append cluster assignment
police_df$cluster_em = as.factor(em_fit$classification)

# Plot results
ggplot(police_df, aes(`non-white`, white, group=cluster_em)) +
  geom_label(aes(label=city, fill=cluster_em))
