library(dplyr)
library(readr)
library(tidyverse)

file_list <- lapply(1:9, function (x) read_csv2(paste0("R", x, "-22.bam_profile.IS_microdiversity_summary.csv")))
md_info <- file_list %>%
  reduce(full_join, by = "genome")
