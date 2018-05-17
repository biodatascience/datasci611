#!/usr/bin/env Rscript
library(tidyverse)

args = commandArgs(trailingOnly=TRUE)
dt = as_tibble(read.table(args[1], header=TRUE, sep=","))

p = ggplot(dt, aes(x=BUSHES, y=BUILDING)) + 
  geom_jitter(size=5, alpha=0.05, width=0.02, height=0.02)
ggsave(filename=args[2])
