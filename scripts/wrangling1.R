library(tidyverse)

# Read in the data
police_df = read_csv(url("https://raw.githubusercontent.com/fivethirtyeight/data/master/police-locals/police-locals.csv"),
                     na = "**")

## filter() - select rows in your dataframe that fit criteria

# Find the cities where the police force contains more than 4000 officers
large_force = filter(police_df, police_force_size > 4000)
large_force

# Find the cities where the police force contains less than 4000 officers and
# less than half of black officers live inside city limits
smaller_force = filter(police_df, police_force_size < 4000, black < 0.5)
smaller_force

# Find the cities where the less than half of black officers live inside city 
# limits or more than half of hispanic officers live inside city limits
or_force = filter(police_df, (black < 0.5) | (hispanic > 0.5))
or_force

# Find the cities where the the percentage of all officers that live inside
# city limits is almost exactly 0.5
half_force = filter(police_df, near(all, 0.5))
half_force

# Find the rows for New York, Miami, and Cincinnati
specific_cities = filter(police_df, city %in% c("New York", "Miami", "Cincinnati"))
specific_cities

# Find the rows where the estimate for Asian officers is NA
asian_na = filter(police_df, is.na(asian))
asian_na

## arrange() - sort your dataframe

# Sort the dataframe by the overall percentage of police officers that live in 
# city limits from smallest to largest
all_sort = arrange(police_df, all)
all_sort

# Sort the dataframe by the overall percentage of police officers that live in 
# city limits from largest to smallest
all_rev_sort = arrange(police_df, desc(all))
all_rev_sort

# Sort the dataframe by the overall percentage of police officers that live in 
# city limits first (ascending order), then by police force size second (ascending order)
all_white_sort = arrange(police_df, all, police_force_size)
all_white_sort

## select() - select columns in your dataframe that fit criteria
# Slicing "col_x:col_y", and inverse slicing "-(col_x:col_y)
# starts_with(), ends_with(), contains(), matches(), everything()
# Select the city, police_force_size and all columns
first_three = select(police_df, city, police_force_size, all)
first_three

# Select the columns that contain the word "white"
white_two = select(police_df, contains('white'))
white_two

# Select the last five columns using slicing
last_five = select(police_df, 4:8)
last_five

# Select the last five columns using inverse slicing
last_five = select(police_df, -(1:3))
last_five

## mutate() - create new variables (i.e. columns) in your dataframe

# Create a new percentage variable "all_perc" that multiplies 
# all by 100
all_perc = mutate(police_df, all_perc = all * 100)
all_perc

# Create a new variable that ranks police forces by size
rank_force = mutate(police_df, rank_size = min_rank(-police_force_size))
rank_force

