bac_tax_class = CSV.File("data/bac_tax_class.tsv") |> DataFrame
arc_tax_class = CSV.File("data/arc_tax_class.tsv") |> DataFrame
tax_class = vcat(bac_tax_class, arc_tax_class)
rename!(tax_class, "user_genome" => :Genome)
select!(tax_class, [:Genome, :classification])
transform!(tax_class, :classification => ByRow(x -> split(x, ';')) => [:Domain, :Phylum, :Class, :Order, :Family, :Genus, :Species])
tax_class = tax_class[!, setdiff(names(tax_class), ["classification"])]
sort!(tax_class, :Genome)

qual_info = CSV.File("data/qual_info.csv") |> DataFrame
keep_rows = map(x -> x ∈ tax_class.Genome, qual_info.Genome)
qual_info = qual_info[keep_rows, :]
sort!(qual_info, :Genome)

abund_prof = CSV.File("data/abund_prof.tsv") |> DataFrame
keep_rows = map(x -> x ∈ tax_class.Genome, abund_prof.Genome)
abund_prof = abund_prof[keep_rows, :]
sort!(abund_prof, :Genome)

relabund_idx = map(x -> occursin("Relative Abundance", x), names(abund_prof))
tpm_idx = map(x -> occursin("TPM", x), names(abund_prof))
rpkm_idx = map(x -> occursin("RPKM", x), names(abund_prof))

relabund_assay = abund_prof[!, relabund_idx] |> Matrix
tpm_assay = abund_prof[!, tpm_idx] |> Matrix
rpkm_assay = abund_prof[!, rpkm_idx] |> Matrix

assays = OrderedDict{String, AbstractArray}("relabund" => relabund_assay,
                                            "tpm" => map(x -> parse(Float64, x), tpm_assay),
                                            "rpkm" => map(x -> parse(Float64, x), rpkm_assay))

feature_data = DataFrame(
    name = abund_prof[!, :Genome]
)
leftjoin!(feature_data, qual_info, on = :name => :Genome)
leftjoin!(feature_data, tax_class, on = :name => :Genome)

sample_data = DataFrame(
    name = ["sample$i" for i in range(1, 9)]
)

se = SummarizedExperiment(assays, feature_data, sample_data)

feature_data[!, :QualityScore] = feature_data.Completeness .- 5 .* feature_data.Contamination
