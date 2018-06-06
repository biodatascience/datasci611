library(tidyverse)
library(clustree)

# Load iris dataset
tiris = as.tibble(iris)
tiris_nolabels = tiris[1:4][]


# Run K-means with multiple values
wss = rep(0, 10)
for(k in 1:10){
  
  # K-Means Cluster Analysis
  fit = kmeans(tiris_nolabels, k) 
  
  # Record within-group sum of squares
  wss[k] = fit$tot.withinss
  
  new_col_name = paste0('kmeans',k,'S')
  # append cluster assignment
  tiris[[new_col_name]] = fit$cluster
  
}

# Visualize movement of samples between clusters
clustree(tiris, prefix='kmeans', suffix='S')

# Visualize number of clusters
plot(1:10, wss, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares")