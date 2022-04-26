using Statistics

features = se.rowdata

function select_top_taxa(se::SummarizedExperiment, assay_name::String, top_n::Int64 = 10, sel_method::Function = mean)

    features[!, :ranking_parameter] = [sel_method(row) for row in eachrow(assay(se, assay_name))]
    dropmissing!(features)

    sort(features, :ranking_parameter, rev = true)[1:top_n, :]

end

top10_taxa = select_top_taxa(se, "relabund")