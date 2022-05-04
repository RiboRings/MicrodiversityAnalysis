using Plots
plot(heatmap(assay(se, "tpm")))