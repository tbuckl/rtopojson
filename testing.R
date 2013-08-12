#testscript
library(devtools)
rm(list = ls())
load_all()
ca <- Topojson$new(file="inst/extdata/cali_nv_ariz.json")
ca$open()
arcs <- ca$arcs
scale <- ca$scale
translate <- ca$translate
topo_poly_to_sp_poly(ca$geometries[[1]],scale,translate,arcs)
a <- ca$topo_poly_to_sp_poly(ca$geometries[[1]])
a
b <- ca$topo_poly_to_sp_poly(ca$geometries[[3]])
b
