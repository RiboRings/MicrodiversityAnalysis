source("prep.R")
top_n_taxa <- 100

rmarkdown::render("report.Rmd",
                  output_format = "html_document",
                  output_file = "report.html")

rmarkdown::render("report.Rmd",
                  output_format = "pdf_document",
                  output_file = "report.pdf")


