#yet more test data
us_data <- "inst/extdata/cali_nv_ariz.json"
us_poly <- fromJSON(paste(readLines(us_data), collapse=""))

#initial test data
json_file < "inst/extdata/example.topojson"
json_data < fromJSON(paste(readLines(json_file), collapse=""))

#example calls from sample data 1
aruba_arc_index < json_data$objects$aruba$arcs
aruba_arcs < json_data$arcs

#example of getting second element from each arc:
lapply(json_data$arcs[[1]],function(x) x[[2]])

#example extractions from parsed topojson
scale < json_data$transform$scale
translate < json_data$transform$translate
arcs < json_data$arcs[[1]]

#apply arc translation to all arcs in example data 1
result < lapply(arcs,rel2abs,scale=scale,translate=translate)

#make sp polygons from topojson
forobject < function(objects,arcs,scale,translate)