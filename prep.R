
knitr::opts_chunk$set(message = FALSE, warning = FALSE, echo = FALSE)

library(ggplot2)
theme_set(theme_bw(20))

library(dplyr)
library(readr)
library(grid)
library(gridExtra)
library(patchwork)
library(tidyverse)
library(plotly)
library(kableExtra)
library(ComplexHeatmap)

mags <- read_csv2("data/Uranouchi_prok_MAGs.csv")

mags$NsrMean[mags$NsrMean == "#DIV/0!"] <- NA
mags <- mags %>%
  mutate(NsrMean = as.numeric(gsub(",", ".", NsrMean)))

g_legend <- function(a.gplot){
  
  tmp <- ggplot_gtable(ggplot_build(a.gplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  
  return(legend)
  
}