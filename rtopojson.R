library("rjson")
library("bitops")

#swiss test data parsing
swiss_data <- "inst/extdata/swissborders.topojson"
swiss_poly <- fromJSON(paste(readLines(swiss_data), collapse=""))

swiss_objects <- swiss_poly$objects$"swiss-cantons"$geometries
arcs <- swiss_poly$arcs
scale <- swiss_poly$transform$scale
translate <- swiss_poly$transform$translate

#value: returns a list of absolute coordinates 
#(often longitude,latitude) 
#arguments: takes an arc 
#(line-string of delta-encoded 
#integer coordinates)
#and (x,y) "scale" and (x,y) "translate" 
rel2abs <- function(arc, scale=Null, translate=Null) {
  if (!is.null(scale) & !is.null(translate)) {
    a <- 0
    b <- 0
    print("newloop")
    lapply(arc,function(point) {    
      a <<- a + point[[1]]
      b <<- b + point[[2]]
      x <- scale[1]*a + translate[1]
      y <- scale[2]*b + translate[2]
      c(x, y)})
  } else {
    c(arc[1], arc[2])
  }
}

bitflipper <- function(i) {
  if (i >= 0) {i = i} else {i = bitFlip(i)}
}

arc_index <- swiss_objects[[5]]$arcs[[1]]

object_types <- lapply(swiss_objects,function(x){x$type})
lapply(swiss_objects[which(object_types=="Polygon")],plot_topojson)

#takes a topojson "Polygon" object and 
#makes it into an SP spatialpolygons object
#and plots it
plot_topojson <- function(object) {

# from the inside out:
#1) flip bits for "the one's complement" (e.g. reversed arcs like -12)
#2) add +1 to the index b/c of R's list indexes
#3) subset all arcs from the total set for the object
#4) apply the transformation to each arc and output as list
arc_index <- object$arcs[[1]]
abs_obj <- lapply(arcs[sapply(arc_index,bitflipper)+1],rel2abs,scale,translate)

#flip the arcs with negative indices
abs_obj[which(arc_index<0)] <- lapply(abs_obj[which(arc_index<0)],rev)

#from inside out:
#1)flatten list of arcs
#2)make a 2-dimensional matrix from them
#3)make an sp polygon class
p1 <- Polygon(do.call(rbind,unlist(abs_obj,recursive=FALSE)))

#plot the polygon
p2 <- Polygons(list(p1),ID="a")
p3 <- SpatialPolygons(list(p2))
plot(p3)
p3

}