#for interactive testing

#swiss test data parsing
swiss_data <- "inst/extdata/swissborders.topojson"
swiss_poly <- fromJSON(paste(readLines(swiss_data), collapse=""))

swiss_objects <- swiss_poly$objects$"swiss-cantons"$geometries
arcs <- swiss_poly$arcs
scale <- swiss_poly$transform$scale
translate <- swiss_poly$transform$translate

arc_index <- swiss_objects[[5]]$arcs[[1]]

object_types <- lapply(swiss_objects,function(x){x$type})

lapply(swiss_objects[which(object_types=="Polygon")],plot_topojson,scale,translate,arcs)
