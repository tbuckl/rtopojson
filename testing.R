#testscript
library(devtools)
rm(list = ls())
load_all()
ca <- Topojson$new(file="inst/extdata/cali_nv_ariz.json")
ca$open()
ca$t2sp()
ca$plot()
