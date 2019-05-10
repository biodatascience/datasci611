library(tidyverse)
library(mclust) 

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
# Classification
#-------------------------
library(caret)

# Expected to be from type 2
new_samples = tibble(gene_a = rnorm(n=10, mean=2), gene_b = rnorm(n=10, mean=2))

# Train a k-nearest-neighbors model
knn_fit = train(type ~ gene_a + gene_b, data = gene_df, method = "knn")

# Predict type for new data
knn_classification = predict(knn_fit, new_samples, type="raw")
new_samples$knn_class = knn_classification

ggplot(gene_df, aes(gene_a, gene_b)) +
  geom_point(size=2, alpha=0.75) +
  geom_point(data=new_samples, size=4, aes(color=new_samples$knn_class)) +
  ggtitle('knn_classification') +
  theme(legend.position = "none")

# Train a support vector machine
svm_fit = train(type ~ gene_a + gene_b, data = gene_df, method = "svmLinear")

# Predict type for new data
svm_classification = predict(svm_fit, new_samples, type="raw")
new_samples$svm_class = svm_classification

ggplot(gene_df, aes(gene_a, gene_b)) +
  geom_point(size=2, alpha=0.75) +
  geom_point(data=new_samples, size=4, aes(color=new_samples$svm_class)) +
  ggtitle('svm_classification') +
  theme(legend.position = "none")

# Train a random forest classifier
rf_fit = train(type ~ gene_a + gene_b, data = gene_df, method = "ranger")

# Predict type for new data
rf_classification = predict(rf_fit, new_samples, type="raw")
new_samples$rf_class = rf_classification

ggplot(gene_df, aes(gene_a, gene_b)) +
  geom_point(size=2, alpha=0.75) +
  geom_point(data=new_samples, size=4, aes(color=new_samples$rf_class)) +
  ggtitle('rf_classification') +
  theme(legend.position = "none")
