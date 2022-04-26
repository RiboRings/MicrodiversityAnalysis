file_list = []

file_list = [CSV.File("data/md$i.csv") |> DataFrame for i in range(1, 9)]

for file in file_list

    replace!(file.pNpS, "NA" => "0")
    file.pNpS = map(x -> parse(Float64, replace(x, ',' => '.')), file.pNpS)

    replace!(file.DiSiperMbp, "NA" => "0")
    file.DiSiperMbp = map(x -> parse(Float64, replace(x, ',' => '.')), file.DiSiperMbp)

end

microdiversity = file_list[1]

for file in file_list[2:end]

    microdiversity = outerjoin(microdiversity, file, on = :genome, makeunique = true)

end

microdiversity.genome = [replace(i, ".fna" => "") for i in microdiversity.genome]
microdiversity = rightjoin(microdiversity, feature_data, on = :genome => :name)
sort!(microdiversity, :genome)

pNpS_idx = map(x -> occursin("pNpS", x), names(microdiversity))
pNpS_assay = microdiversity[!, pNpS_idx] |> Matrix

DiSiperMbp_idx = map(x -> occursin("DiSiperMbp", x), names(microdiversity))
DiSiperMbp_assay = microdiversity[!, DiSiperMbp_idx] |> Matrix

se.assays["pNpS"] = pNpS_assay
se.assays["DiSiperMbp"] = DiSiperMbp_assay