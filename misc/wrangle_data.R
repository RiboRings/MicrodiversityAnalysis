library(dplyr)
library(readr)
library(readxl)

for (i in 1:10) {
  
  x1 <- read_csv2(paste0("data/md", i, ".csv"))
  x2 <- read_csv2(paste0("data/qc", i, ".csv"))
  x_out <- full_join(x1, x2)
  write_csv2(x_out, paste0("data/md", i, ".csv"))
  
}

file_list <- list()

for (i in 1:9) {

  file_list[[i]] <- read_csv2(paste0("data/md", i, ".csv"))
  
}

library(tidyverse)

full_dataset <- file_list %>% reduce(full_join, by = "genome")
