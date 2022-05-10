source("prep.R")
rpkm_threshold <- 1

rmarkdown::render("report.Rmd",
                  output_format = "html_document",
                  output_file = "report.html")

rmarkdown::render("report.Rmd",
                  output_format = "pdf_document",
                  output_file = "report.pdf")


