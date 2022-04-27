using Statistics
using SummarizedExperiments

function select_top_taxa(se::SummarizedExperiment, assay_name::String; top_n::Int64 = 10, sel_method::Function = mean)

    features = copy(se.rowdata)
    features[!, Symbol(assay_name)] = [sel_method(row) for row in eachrow(assay(se, assay_name))]

    sort(dropmissing(features, Symbol(assay_name)), Symbol(assay_name), rev = true)[1:top_n, :]

end

function select_top_taxa(se::SummarizedExperiment, assay_names::Vector{String}; top_n::Int64 = 10, sel_method::Function = mean)

    features = copy(se.rowdata)

    for ass in assay_names
        
        features[!, Symbol(ass)] = [sel_method(row) for row in eachrow(assay(se, ass))]

    end

    sort(dropmissing(features, Symbol.(assay_names)), Symbol.(assay_names), rev = true)[1:top_n, :]

end

top10_pNpS_taxa = select_top_taxa(se, "pNpS")
top10_rpkm_taxa = select_top_taxa(se, "rpkm")
combo = select_top_taxa(se, ["rpkm", "pNpS"])
