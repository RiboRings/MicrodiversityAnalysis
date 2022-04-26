library(dplyr)
library(readr)
library(ggplot2)
library(grid)
library(gridExtra)

pNpS_threshold <- 1

pNpS_assay <- read_csv("output/pNpS_assay.csv") %>%
  filter(!is.na(sample1))
DiSiperMbp_assay <- read_csv("output/DiSiperMbp_assay.csv") %>%
  filter(!is.na(sample1))
rpkm_assay <- read_csv("output/rpkm_assay.csv")

plots <- list()

for (i in 1:9) {
  
  df <- pNpS_assay[ , c(i, ncol(pNpS_assay))] %>%
    full_join(DiSiperMbp_assay[ , c(i, ncol(DiSiperMbp_assay))],
              by = "genome") %>%
    full_join(rpkm_assay[ , c(i, ncol(rpkm_assay))],
              by = "genome") %>%
    rename(pNpS = paste0("sample", i, ".x"),
           DiSiperMbp = paste0("sample", i, ".y"),
           rpkm = paste0("sample", i)) %>%
    filter(rpkm > pNpS_threshold)
  
  plots[[i]] <- ggplot(df, aes(x = DiSiperMbp, y = pNpS, colour = rpkm)) +
    geom_point() +
    labs(x = element_blank(), y = element_blank(), subtitle = paste("sample", i)) +
    theme_classic()
  
}

g_legend<-function(a.gplot){
  tmp <- ggplot_gtable(ggplot_build(a.gplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend) }

# extract legend as a grob
leg <- g_legend(plots[[length(plots)]])

grid.arrange(
  arrangeGrob(grobs=lapply(plots, function(p) p + guides(colour=FALSE)), ncol=3, 
              bottom=textGrob("DiSiperMbp", gp=gpar(fontface="bold", col="red", fontsize=15)), 
              left=textGrob("pNpS", gp=gpar(fontface="bold", col="blue", fontsize=15), rot=90)),
  leg, 
  widths=c(9,1)
  
)

