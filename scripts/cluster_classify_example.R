library(tidyverse)

# A quick refresher on native R clustering algorithms: https://www.statmethods.net/advstats/cluster.html

# Set the random seed
set.seed(0)

# Generate example data set
N = 30
U1 = 1
U2 = 4.5
gene_df = rbind(tibble(gene_a = rnorm(n=N, mean=U2), gene_b = rnorm(n=N, mean=U1), explant_id = seq(1, N), type = 1),
                tibble(gene_a = rnorm(n=N, mean=U1), gene_b = rnorm(n=N, mean=U1), explant_id = seq(N+1, 2*N), type = 2),
                tibble(gene_a = rnorm(n=N, mean=U1), gene_b = rnorm(n=N, mean=U2), explant_id = seq((2*N)+1, 3*N), type = 3))
gene_df$type = as.factor(gene_df$type)

ggplot(gene_df, aes(gene_a, gene_b)) +
  geom_point(size=2, alpha=0.75)

#-------------------------
# K-means clustering
#-------------------------
fit = gene_df %>%
  select(gene_a, gene_b) %>%
  kmeans(3) 

# Append cluster assignment
gene_df$cluster = as.factor(fit$cluster)

# Plot results
ggplot(gene_df, aes(gene_a, gene_b, group=cluster)) +
  geom_point(size=2, alpha=0.75, aes(color=cluster))

# How many clusters should we pass to the k-means algorithm?

#-------------------------
# Determine an appropriate 
# number of clusters for the
# data
#-------------------------
kmeans_wss <- Vectorize(function(c){
  return(sum(kmeans(gene_df, centers=c)$withinss))
})

cluster_fit = tibble(num_centers=1:15) %>%
  mutate(wss = kmeans_wss(num_centers), diff_wss = wss - lag(wss))

ggplot(cluster_fit, aes(num_centers, wss)) +
  geom_point() +
  geom_line() +
  labs(x="Number of Clusters",
       y="Within groups sum of squares") 

#-------------------------
# Hierarchical clustering
#-------------------------
# Calculate distance between all observations
dist_mat = gene_df %>%
  select(gene_a, gene_b) %>%
  dist(method = "euclidean") 

# Cluster closest first, then work outwards
hfit = hclust(dist_mat, method="average") 
plot(hfit) 

# Append cluster assignment
groups = cutree(hfit, k=3) 
gene_df$cluster_h = as.factor(groups)

rect.hclust(hfit, k=3, border="red")

# Plot results
ggplot(gene_df, aes(gene_a, gene_b, group=cluster)) +
  geom_point(size=2, alpha=0.75, aes(color=cluster))


#-------------------------
# Classification
#-------------------------
library(caret)

# Expected to be from type 2
new_samples = tibble(gene_a = rnorm(n=10, mean=1), gene_b = rnorm(n=10, mean=1))

# Train a k-nearest-neighbors model
knn_fit = train(type ~ gene_a + gene_b, data = gene_df, method = "knn")

# Predict type for new data
knn_classification = predict(knn_fit, new_samples, type="raw")

# Train a support vector machine
svm_fit = train(type ~ gene_a + gene_b, data = gene_df, method = "svmLinear")

# Predict type for new data
svm_classification = predict(svm_fit, new_samples, type="raw")
