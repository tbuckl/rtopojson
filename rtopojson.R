library("rjson")

#swiss test data parsing
swiss_data <- "inst/extdata/swissborders.topojson"
swiss_poly <- fromJSON(paste(readLines(swiss_data), collapse=""))

swiss_scale <- swiss_poly$transform$scale
swiss_translate <- swiss_poly$transform$translate

swiss_objects <- swiss_poly$objects$"swiss-cantons"$geometries
swiss_arcs <- swiss_poly$arcs
single_swiss_object_arc_index <- swiss_objects[[1]]$arcs

#going from relative to absolute coordinates
rel2abs <- function(arc, scale=Null, translate=Null) {
  if (!is.null(scale) & !is.null(translate)) {
    a <- 0
    b <- 0
    a <- a + arc[[1]]
    b <- b + arc[[2]]
    x <- scale[1]*a + translate[1]
    y <- scale[2]*b + translate[2]
    c(x, y)
  } else {
    c(arc[1], arc[2])
  }
}

TopoToPoly <- function(single_arc_index,all_arcs,scale,translate) {  
  select_arc <- unlist(all_arcs[single_arc_index+1],recursive=FALSE)
  list_of_absolute_coords <- lapply(select_arc,rel2abs,scale=scale,translate=translate)
  closing_vertex<-unlist(select_arc[1])
  closing_vertex_absolute <- rel2abs(closing_vertex,scale,translate)
  list_of_absolute_coords[[length(list_of_absolute_coords)+1]] <- closing_vertex_absolute
  Polygon(do.call(rbind, list_of_absolute_coords))
}

TopoToPolys <- function(object,arcs) {
  
}

apply()

object <- unlist(single_swiss_object_arc_index,recursive=FALSE)

apply(object,1,TopoToPoly,swiss_arcs,scale=swiss_scale,translate=swiss_translate)

result <- TopoPolyToSp(single_swiss_object_arc_index[[1]][[1]],swiss_arcs,scale=swiss_scale,translate=swiss_translate)

#TODO:other test data

#yet more test data
us_data <- "inst/extdata/cali_nv_ariz.topojson"
us_poly <- fromJSON(paste(readLines(us_data), collapse=""))

#example calls from sample data 1
aruba_arc_index <- json_data$objects$aruba$arcs
aruba_arcs <- json_data$arcs

#initial test data
json_file <- "inst/extdata/example.topojson"
json_data <- fromJSON(paste(readLines(json_file), collapse=""))

#example of getting second element from each arc:
lapply(json_data$arcs[[1]],function(x) x[[2]])

#example extractions from parsed topojson
scale <- json_data$transform$scale
translate <- json_data$transform$translate
arcs <- json_data$arcs[[1]]


#apply arc translation to all arcs in example data 1
result <- lapply(arcs,rel2abs,scale=scale,translate=translate)


#make sp polygons from topojson
forobject <- function(objects,arcs,scale,translate) {
  
}