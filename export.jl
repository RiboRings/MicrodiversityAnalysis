using CSV, DataFrames, DataStructures
using SummarizedExperiments

include("summarized_experiment.jl")
include("microdiversity.jl")

export_pNpS = DataFrame(assay(se, "pNpS"), Symbol.(sample_data.name))
export_pNpS[!, :genome] = feature_data.name
CSV.write("output/pNpS_assay.csv", export_pNpS)

export_DiSiperMbp = DataFrame(assay(se, "DiSiperMbp"), Symbol.(sample_data.name))
export_DiSiperMbp[!, :genome] = feature_data.name
CSV.write("output/DiSiperMbp_assay.csv", export_DiSiperMbp)

export_rpkm = DataFrame(assay(se, "rpkm"), Symbol.(sample_data.name))
export_rpkm[!, :genome] = feature_data.name
CSV.write("output/rpkm_assay.csv", export_rpkm)