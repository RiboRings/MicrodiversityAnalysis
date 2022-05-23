using MicrobiomeAnalysis
using XLSX, DataFrames, DataStructures

raw_data = XLSX.readdata("data/Uranouchi_prok_MAGs.xlsx", "main", "A1:L697") |> Matrix
df = DataFrame(raw_data[2:end, :], raw_data[1, :])
rename!(df, :Bin => "name")
df[!, :name] .= String.(df[!, :name])

tpm = XLSX.readdata("data/Uranouchi_prok_MAGs.xlsx", "main", "AN2:AV697") |> Matrix
rpkm = XLSX.readdata("data/Uranouchi_prok_MAGs.xlsx", "main", "AW2:BE697") |> Matrix
pNpS = XLSX.readdata("data/Uranouchi_prok_MAGs.xlsx", "main", "AE2:AM697") |> Matrix
nucl_div = XLSX.readdata("data/Uranouchi_prok_MAGs.xlsx", "main", "V2:AD697") |> Matrix
NSF = XLSX.readdata("data/Uranouchi_prok_MAGs.xlsx", "main", "BF2:BN697") |> Matrix
DiSiperMbp = XLSX.readdata("data/Uranouchi_prok_MAGs.xlsx", "main", "M2:U697") |> Matrix

pNpS[pNpS .== "NA"] .= missing
nucl_div[nucl_div .== "NA"] .= missing
NSF[NSF .== "NA"] .= missing
DiSiperMbp[DiSiperMbp .== "NA"] .= missing

assays = OrderedDict{String, AbstractArray}("tpm" => tpm,
                                            "rpkm" => rpkm,
                                            "pNpS" => pNpS,
                                            "nucl_div" => nucl_div,
                                            "NSF" => NSF,
                                            "DiSiperMbp" => DiSiperMbp)

col_data = DataFrame(
    name = ["sample$i" for i in 1:9]
)

se = SummarizedExperiment(assays, df, col_data)
