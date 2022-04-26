using CSV, DataFrames, DataStructures

file_list = []

file_list = [CSV.File("data/md$i.csv") |> DataFrame for i in range(1, 9)]

for file in file_list

    replace!(file.pNpS, "NA" => "0")
    file.pNpS = map(x -> parse(Float64, replace(x, ',' => '.')), file.pNpS)

    replace!(file.DiSiperMbp, "NA" => "0")
    file.DiSiperMbp = map(x -> parse(Float64, replace(x, ',' => '.')), file.DiSiperMbp)

end

microdiversity = outerjoin(file_list[1],
                        file_list[2],
                        file_list[3],
                        file_list[4],
                        file_list[5],
                        file_list[6],
                        file_list[7],
                        file_list[8],
                        file_list[9],
                        on = :genome, makeunique = true)

pNpS_idx = map(x -> occursin("pNpS", x), names(microdiversity))

pNpS_assay = microdiversity[!, pNpS_idx] |> Matrix