#' Translate delta-encoded integer coordinates to absolute coordinates
#' @param arc line-string of delta-encoded integer coordinates
#' @param scale scaling to apply to x and y 
#' @param translate to apply to x and y 
#' @export
#' @return list of absolute coordinates (often longitude,latitude) 
rel2abs <- function(arc, scale=Null, translate=Null) {
  if (!is.null(scale) & !is.null(translate)) {
    a <- 0
    b <- 0
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

library("rjson")
library("bitops")

# Because JSON stores 0 index values for arrays, the TopoJSON spec uses
# bitflipping to store negative indices to avoid confusion with 0.
# For example, -1 referse to the inverse arc of 0.  
bitflipper <- function(i) {
  if (i >= 0) {i = i} else {i = bitFlip(i)}
}

#' Turns polygons in a given TopoJSON object into a list of sp polygons
#' @description For a given arc index, which is a list of the arcs which belong 
#' a TopoJSON object, this function pulls the necessary arcs, calling \code{\link{rel2abs}}
#' to convert them from delta-encoded to absolute coordinates, and where necessary, flipping 
#' arcs which must be referred to in reverse to make a continuous polygon.  This is necessary because
#' TopoJSON indexes some arcs as "positive" and others as "negative" integers
#' to allow for arcs which can be either "right" or "left" of a given polygon, TopoJSON 
#' 
#' @param topojson_object is a TopoJSON "Polygon" which contains, at the least, an index of arrays, and often
#' contains a names and other variables
#' @param scale scaling to apply to x and y 
#' @param translate to apply to x and y 
#' @param arcs line-strings of delta-encoded integer coordinates for all features in the TopoJSON file
#' @return list of sp Polygons
topo_poly_to_sp_poly <- function(topojson_object,scale,translate,arcs) {

# from the inside out:
# 1) flip bits for "the one's complement" (e.g. reversed arcs like -12)
# 2) add +1 to the index b/c of R's list indexes
# 3) subset all arcs from the total set for the object
# 4) apply the transformation to each arc and output as list
arc_index <- topojson_object$arcs[[1]]
abs_obj <- lapply(arcs[sapply(arc_index,bitflipper)+1],rel2abs,scale,translate)

# flip the arcs with negative indices
abs_obj[which(arc_index<0)] <- lapply(abs_obj[which(arc_index<0)],rev)

# from inside out:
# 1)flatten list of arcs
# 2)make a 2-dimensional matrix from them
# 3)make an sp polygon class
Polygon(do.call(rbind,unlist(abs_obj,recursive=FALSE)))

}



