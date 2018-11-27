library(tidyverse)

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
# Classify new city
#-------------------------
library(caret)

new_cities_df = tibble(all=c(0.89, 0.51, 0.1), 
                       white=c(0.93, 0.34, 0.01), 
                       `non-white`=c(0.65, 0.2, 0.3))

# Train a k-nearest-neighbors model
knn_fit = train(cluster ~ all + white + `non-white`, data = police_df, method = "knn")

# Predict type for new data
knn_classification = predict(knn_fit, new_cities_df, type="raw")

new_cities_df$cluster = knn_classification

# Plot results
ggplot(police_df, aes(`non-white`, white, group=cluster)) +
  geom_label(aes(label=city, fill=cluster)) +
  geom_label(data=new_cities_df, color='red', label='new')
