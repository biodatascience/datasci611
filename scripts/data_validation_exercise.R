library(tidyverse)

police_df = read_csv(url('https://raw.githubusercontent.com/fivethirtyeight/data/master/police-locals/police-locals.csv'), na = '**')

#-----------------------------------
# Standardize
#-----------------------------------
preproc_vals = police_df %>%
  preProcess(method = c("center", "scale"))

police_standardized = predict(preproc_vals, police_df)

# "police_force_size" is a few orders of magnitude larger than the other variables
# and would dominate any composite score such as distance

#-----------------------------------
# Impute missing values
#-----------------------------------
preproc_vals = police_df %>%
  preProcess(method = c("knnImpute"))

police_imputed = predict(preproc_vals, police_df)

# The "asian" variable consists almost entirely of missing data.

#-----------------------------------
# PCA dimensionality reduction
#-----------------------------------
pca = police_imputed %>%
  select(-city) %>%
  prcomp()

police_pca = as.tibble(pca$x)
police_pca$city = police_imputed$city

ggplot(police_pca, aes(PC1, PC2)) +
  geom_label(aes(label=city))

#-----------------------------------
# Split 80/20
#-----------------------------------
train_i = createDataPartition(police_imputed$asian, p = .5, list=FALSE)
train_df = police_imputed[train_i,]
test_df = police_imputed[-train_i,]

model = lm(black ~ police_force_size + white, data=train_df)

residuals = test_df %>%
  select(white, police_force_size, black) %>%
  add_residuals(model) %>%
  .$resid 

sum(residuals^2)
