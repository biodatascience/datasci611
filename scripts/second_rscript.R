#!/usr/bin/env Rscript
# Run this from the command line using Rscript

args = commandArgs(trailingOnly=TRUE)

print('Hello, world!')

a = sqrt(as.numeric(args[1]))

print(a)