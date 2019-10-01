library(tidyverse)
library(caret)

## Standardization example (i.e. centering and scaling)

# First, notice how halving one variable or another 
# impacts the distance between observations
astronaut_df = tibble(astronaut_id = c(13, 45, 81), 
                      age = c(36, 47, 38), 
                      heart_rate = c(45, 52,42), 
                      hours_in_space = c(2208, 3791, 1823))

# Exclude astronaut IDs
adf_0 = astronaut_df %>% select(-astronaut_id)
d0 = dist(adf_0)

adf_1 = adf_0
adf_1[1, 3] = 0.5 * adf_0[1, 3]
d1 = dist(adf_1 )
delta1 = (d1 - d0)/d0

adf_2 = adf_0
adf_2[1, 2] = 0.5 * adf_0[1, 2]
d2 = dist(adf_2)
delta2 = (d2 - d0)/d0

# Notice that the relative change in distance is much greater for delta1

# Now standardize the data by converting to z-scores
# Test the distance scores again
astronaut_stnd_df = astronaut_df %>%
  mutate(age = (age - mean(age))/sd(age), 
         heart_rate = (heart_rate - mean(heart_rate)) / sd(heart_rate),
         hours_in_space = (hours_in_space - mean(hours_in_space)) / sd(hours_in_space))

adf_3 = astronaut_stnd_df %>% select(-astronaut_id)
d3 = dist(adf_3)

adf_4 = adf_3
adf_4[1, 3] = 0.5 * adf_3[1, 3]
d4 = dist(adf_4)
delta4 = (d4 - d3)/d3

adf_5 = adf_3
adf_5[1, 2] = 0.5 * adf_3[1, 2]
d5 = dist(adf_5)
delta5 = (d5 - d3)/d3

# Notice that the relative change in distance 
# is similar between the two variables

## Now let's standardize using caret
astro_preproc_vals = adf_0 %>%
  preProcess(method = c("center", "scale"))

astronaut_stnd_df_2 = predict(astro_preproc_vals, astronaut_df)

## Curse of dimensionality
# Add three new variables
astronaut_df$weight = c(172, 169, 201)
astronaut_df$height = c(69, 64, 73)
astronaut_df$systolic = c(124, 118, 129)

adf_6 = astronaut_df %>% select(-astronaut_id)

# Standardize
astro_preproc_vals = adf_6 %>%
  preProcess(method = c("center", "scale"))

astronaut_stnd_df_3 = predict(astro_preproc_vals, astronaut_df)

# Check the effect on the distance metric of halving a variable
adf_7 = astronaut_stnd_df_3 %>% select(-astronaut_id)
d7 = dist(adf_7)

adf_8 = adf_7
adf_8[1, 3] = 0.5 * adf_7[1, 3]
d8 = dist(adf_8)
delta8 = (d8 - d7)/d7 # Compare to delta4

## Curse of dimensionality
# Add 500 new variables
astronaut_stnd_df_4 = astronaut_stnd_df_3
astronaut_stnd_df_4 = cbind(astronaut_stnd_df_4, matrix(rnorm(1500), ncol=500))

adf_9 = astronaut_stnd_df_4 %>% select(-astronaut_id)
d9 = dist(adf_9)

adf_10 = adf_9
adf_10[1, 3] = 0.5 * adf_9[1, 3]
d10 = dist(adf_10)
delta10 = (d10 - d9)/d9 # Compare to delta4 and delta8

## PCA transformation in caret
astro_preproc_vals = adf_9 %>%
  preProcess(method = c("pca")) # Automatically selects enough principal components to capture 95% variance

astronaut_stnd_df_5 = predict(astro_preproc_vals, astronaut_stnd_df_4)
 
## K-nearest-neighbors imputation in caret
# Add a missing value
adf_11 = astronaut_df 
adf_11[3,2] = NA

astro_preproc_vals = adf_11 %>%
  select(-astronaut_id) %>%
  preProcess(method = c("knnImpute"), k=1) # Fills in missing values based on the nearest neighbor

astronaut_stnd_df_5 = predict(astro_preproc_vals, adf_11)

## Overfitting
# Add a few more data points to astronaut data 
library(modelr)
set.seed(0)
N = 20
ages = sample(seq(28,57), replace=T, size=N)
hours_in_space = ages * 100 - sample(seq(-500,500), replace=T, size=N)
astronaut_df = tibble(astronaut_id = c(c(13, 45, 81), seq(81+1,81+N,1)), 
                      age = c(c(36, 47, 38), ages), 
                      heart_rate = c(c(45, 52,42), sample(seq(38,61), replace=T, size=N)), 
                      hours_in_space = c(c(2208, 3791, 1823), hours_in_space ))

ggplot(astronaut_df, aes(age, hours_in_space)) +
  geom_point(size=2, alpha=0.5)

model1 = lm(hours_in_space ~ age, data = astronaut_df)
model5 = lm(hours_in_space ~ (age^5) + I(age^4) + I(age^3) + I(age^2) + age, data = astronaut_df)
model15 = lm(hours_in_space ~ I(age^15) + I(age^14) + I(age^13) + I(age^12) + I(age^11) + I(age^10) + I(age^9) + I(age^8) + I(age^7) + I(age^6) + I(age^5) + I(age^4) + I(age^3) + I(age^2) + age, data = astronaut_df)

overfit_model = astronaut_df %>%
  data_grid(age) %>%
  gather_predictions(model1, model5, model15) %>%
  mutate(hours_in_space = pred)

ggplot(astronaut_df, aes(age, hours_in_space)) +
  geom_point(size=2, alpha=0.5) +
  geom_line(data=overfit_model, size=2, alpha=0.5, aes(color=factor(model))) 

# Quantify error on test data
sse <- function(residuals) {
  sse_val = sum(residuals^2)
  return(sse_val)
}

sse_test <- function(test_set, model){
  residuals_tmp = test_set %>% 
    add_residuals(model, var='r15') %>% 
    .$r15 %>% 
    sse()
}

# Before training models, break into training and testing data sets
train_i = createDataPartition(astronaut_df$astronaut_id, p = .5, list=FALSE)
train_df = astronaut_df[train_i,]
test_df = astronaut_df[-train_i,]

model1 = lm(hours_in_space ~ age, data = train_df)
model5 = lm(hours_in_space ~ (age^5) + I(age^4) + I(age^3) + I(age^2) + age, data = train_df)
model15 = lm(hours_in_space ~ I(age^15) + I(age^14) + I(age^13) + I(age^12) + I(age^11) + I(age^10) + I(age^9) + I(age^8) + I(age^7) + I(age^6) + I(age^5) + I(age^4) + I(age^3) + I(age^2) + age, data = train_df)

overfit_model2 = test_df %>%
  data_grid(age) %>%
  gather_predictions(model1, model5, model15) %>%
  mutate(hours_in_space = pred)

ggplot(test_df, aes(age, hours_in_space)) +
  geom_point(size=2, alpha=0.5) +
  geom_line(data=overfit_model2, size=2, alpha=0.5, aes(color=factor(model)))

model_list = list(model1, model5, model15)
sse_values = rep(0,3)
for(i in 1:length(model_list)){
  sse_values[i] = sse_test(test_df, model_list[[i]])
}

# N-fold cross validation - do the same thing as above,
# but multiple times
train_i = createDataPartition(astronaut_df$astronaut_id, p = .5, list=FALSE, times=10)
sse_tibble = tibble()
for(i in 1:ncol(train_i)){
  train_df = astronaut_df[train_i[,i],]
  test_df = astronaut_df[-train_i[,i],]
  
  model1 = lm(hours_in_space ~ age, data = train_df)
  model5 = lm(hours_in_space ~ (age^5) + I(age^4) + I(age^3) + I(age^2) + age, data = train_df)
  model15 = lm(hours_in_space ~ I(age^15) + I(age^14) + I(age^13) + I(age^12) + I(age^11) + I(age^10) + I(age^9) + I(age^8) + I(age^7) + I(age^6) + I(age^5) + I(age^4) + I(age^3) + I(age^2) + age, data = train_df)
  
  model_list = list(model1, model5, model15)
  sse_values = rep(0,3)
  for(i in 1:length(model_list)){
    sse_values[i] = sse_test(test_df, model_list[[i]])
  }
  sse_tibble = rbind(sse_tibble, sse_values)
}
names(sse_tibble) = c('model1', 'model5', 'model15')
print(sse_tibble)

sse_tibble %>% 
  summarise(m1 = mean(model1), m5 = mean(model5), m15 = mean(model15))
