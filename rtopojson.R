library("rjson")

#initial test data
json_file <- "/Users/tom/Documents/codeprojects/example.topojson"
json_data <- fromJSON(paste(readLines(json_file), collapse=""))

#more test data
swiss_data <- "/Users/tom/Documents/codeprojects/swissmiss.topojson"
swiss_poly <- fromJSON(paste(readLines(swiss_data), collapse=""))

#example of getting second element from each arc:
lapply(json_data$arcs[[1]],function(x) x[[2]])

#get data from parsed topojson
scale <- json_data$transform$scale
translate <- json_data$transform$translate
arcs <- json_data$arcs[[1]]

#going from relative to absolute coordinates
rel2abs <- function(arc, scale=Null, translate=Null) {
  if (!is.null(scale) & !is.null(translate)) {
    a <- 0
    b <- 0
    print(arc)
    a <- a + arc[[1]]
    b <- b + arc[[2]]
    c(scale[1]*a + translate[1], scale[2]*b + translate[2])
  } else {
    c(arc[1], arc[2])
  }
}

#apply arc translation to all arcs 
lapply(arcs,rel2abs,scale=scale,translate=translate)

#example call
swiss_objects <- swiss_poly$objects$"swiss-cantons"$geometries
swiss_arcs <- swiss_poly$arcs
single_swiss_object_arc_index <- swiss_geometries[[1]]$arcs
single_swiss_object_arc_index

aruba_arc_index <- json_data$objects$aruba$arcs
aruba_arcs <- json_data$arcs

SpatialPolygon <- forpolygon(object_arc_index,arcs,scale,translate)

forpolygon <- function(arc_index,arcs,scale,translate) {
  
}

#make sp polygons from topojson
forobject <- function(objects,arcs,scale,translate) {
  
}