rpkm_assay <- read_csv("output/rpkm_assay.csv") %>%
  rename(Bin = genome)

mags <- read_csv2("data/Uranouchi_prok_MAGs.csv") %>%
  left_join(rpkm_assay)

tmp <- read_csv2("data/tmp.csv")


mags_filtered <- tmp[ , 49:57] %>%
  na.omit() %>%
  as.matrix() %>%
  heatmap()

plots <- list()

for (i in 1:9) {
  
  plots[[i]] <- tmp %>%
  mutate(Y = eval((parse(text = paste0("nucl_diversity_", i ,"/ DiSiperMbp_", i)))),
         X = eval((parse(text = paste0("RPKM_", i)))),
         colour = eval(parse(text = paste0("pNpS_", i)))) %>%
  ggplot(aes(x = X, y = Y, colour = colour)) +
    geom_point() +
    labs(x = element_blank(), y = element_blank(),
         subtitle = paste("sample", i)) +
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
              bottom=textGrob("RPKM", gp=gpar(fontface="bold", col="red", fontsize=15)), 
              left=textGrob("ND/DiSiperMbp", gp=gpar(fontface="bold", col="blue", fontsize=15), rot=90)),
  leg, 
  widths=c(9,1)
  
)
