using Statistics

top10_pNpS_taxa = select_top_taxa(se, "pNpS")
top10_rpkm_taxa = select_top_taxa(se, "rpkm")
combo = select_top_taxa(se, ["rpkm", "pNpS"])

function abundance_plot2(se::SummarizedExperiment, assay_name::String; top_n = size(se, 1))

    if sum("time" .== names(coldata(se))) == 0

        error("coldata(se) should include a column named 'time' containing an array of sampling times; for example, add it with coldata(se).time = 1:10 if there are 10 samples.")

    end

    top_features = select_top_taxa(se, assay_name, top_n = top_n)
    keep_rows = map(x -> x ∈ top_features.name, se.rowdata.name)
    se_subset = se[keep_rows, :]

    labels = reshape(se_subset.rowdata.name, (1, length(se_subset.rowdata.name)))

    p = plot(se_subset.coldata.time, assay(se_subset, assay_name)',
             label = labels, legend_position = :outerleft,
             xaxis = "Time", yaxis = assay_name)

    return(p)

end

abundance_plot2(se, "pNpS", top_n = 3)

# needs fixing
function filter(se::SummarizedExperiment, assay_name::String; filt_method::Function = x -> mean(x) > 1, remove_missing::Bool = false)


    ass = ifelse(remove_missing, dropmissing(assay(se, assay_name)), assay(se, assay_name))

    keep_rows = map(filt_method, eachrow(ass))
    
    se[keep_rows, :]

end

a = filter(se, "rpkm")
f = filter(se, "pNpS", x -> mean(x) > 2)