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
#' Note that because the goal of this package is to work with external data
#' the examples below are based on a parsed JSON file.  Examples can be found in the
#' inst/extdata directory.  
#' For example, to open and parse a topojson file on swiss "cantons" one would:
#' \code{swiss_data <- "inst/extdata/swissborders.topojson"}
#' \code{swiss_poly <- fromJSON(paste(readLines(swiss_data), collapse=""))}
#' 
#' @param topojson_object is a TopoJSON "Polygon" which contains, at the least, an index of arrays, and often
#' contains a names and other variables
#' @param scale scaling to apply to x and y 
#' @param translate to apply to x and y 
#' @param arcs line-strings of delta-encoded integer coordinates for all features in the TopoJSON file
#' @return list of sp Polygons
#' @examples
#' swiss_objects <- swiss_poly$objects$"swiss-cantons"$geometries
#' arcs <- swiss_poly$arcs
#' scale <- swiss_poly$transform$scale
#' translate <- swiss_poly$transform$translate
#' object_types <- lapply(swiss_objects,function(x){x$type})
#' sppolys <- lapply(swiss_objects[which(object_types=="Polygon")],topo_poly_to_sp_poly,scale,translate,arcs)
#' p2 <- Polygons(list(sppolys[[1]]),ID="a")
#' p3 <- SpatialPolygons(list(p2))
#' plot(p3)
#' @export
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

topo_arc_to_sp_line <- function(arc,scale,translate) {

abs_ln <- rel2abs(arc,scale,translate)

Lines(list(Line(abs_ln)))

}


#' Plots a list of SP Polygons
#' @param polylist list of sp 'Polygon'
#' @param names vector of names for the polygons, optional
#' @return a SpatialPolygons object and a plot
#' @export
plotpolys <- function(polylist,names=c()) {
  if(length(names) == 0) {names = as.character(c(1:length(polylist)))} else {}
  cons <- list()
  for(i in 1:length(polylist)){
    print(str(polylist[i]))
    cons[i] <- Polygons(polylist[i], names[i])
  }
  p3 <- SpatialPolygons(cons,1:length(cons))
  plot(p3)
}

#' single arc to an sp "line" class
arc2sp.line <- function(arq) {
  zp <- lapply(arq,rel2abs,abt$scale,abt$translate)
  Line(matrix(unlist(zp),ncol=2,byrow=TRUE))
}

#' list of arcs to an sp SpatialLines class
#' @param arqs topojson arcs from rtopojson class
#' @return a SpatialLines object
#' @export
arcs2sp.line <-function(arqs) {
  z = list()
  for(i in seq_along(arqs)){
    z[i] <- Lines(list(arc2sp.line(arqs[i])),ID=as.character(i))    
  }
  SpatialLines(z)
}


