library(testthat) 

source('datasci611_src/scripts/util.R')

test_results = test_dir("datasci611_src/scripts/test", reporter="summary")
