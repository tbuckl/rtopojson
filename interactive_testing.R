#for interactive testing
library(sp)

#swiss test data parsing
swiss_data <- "inst/extdata/swissborders.topojson"
swiss_poly <- fromJSON(paste(readLines(swiss_data), collapse=""))

swiss_objects <- swiss_poly$objects$"swiss-cantons"$geometries


arc_index <- swiss_objects[[5]]$arcs[[1]]

object_types <- lapply(swiss_objects,function(x){x$type})

#parse all topojson polygon objects into sp polygons and return list of sp polygons
sppolys <- lapply(swiss_objects[which(object_types=="Polygon")],topopoly_to_sp_poly,scale,translate,arcs)

#plot one of the polygons as an example

p2 <- Polygons(list(sppolys[[1]]),ID="a")

p3 <- SpatialPolygons(list(p2))
plot(p3)
p3
