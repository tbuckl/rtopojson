\name{topo_poly_to_sp_poly}
\alias{topo_poly_to_sp_poly}
\title{Turns polygons in a given TopoJSON object into a list of sp polygons}
\usage{
  topo_poly_to_sp_poly(topojson_object, scale, translate,
    arcs)
}
\arguments{
  \item{topojson_object}{is a TopoJSON "Polygon" which
  contains, at the least, an index of arrays, and often
  contains a names and other variables}

  \item{scale}{scaling to apply to x and y}

  \item{translate}{to apply to x and y}

  \item{arcs}{line-strings of delta-encoded integer
  coordinates for all features in the TopoJSON file}
}
\value{
  list of sp Polygons
}
\description{
  For a given arc index, which is a list of the arcs which
  belong a TopoJSON object, this function pulls the
  necessary arcs, calling \code{\link{rel2abs}} to convert
  them from delta-encoded to absolute coordinates, and
  where necessary, flipping arcs which must be referred to
  in reverse to make a continuous polygon.  This is
  necessary because TopoJSON indexes some arcs as
  "positive" and others as "negative" integers to allow for
  arcs which can be either "right" or "left" of a given
  polygon, TopoJSON

  Note that because the goal of this package is to work
  with external data the examples below are based on a
  parsed JSON file.  Examples can be found in the
  inst/extdata directory. For example, to open and parse a
  topojson file on swiss "cantons" one would:
  \code{swiss_data <- "inst/extdata/swissborders.topojson"}
  \code{swiss_poly <- fromJSON(paste(readLines(swiss_data),
  collapse=""))}
}
\examples{
swiss_objects <- swiss_poly$objects$"swiss-cantons"$geometries
arcs <- swiss_poly$arcs
scale <- swiss_poly$transform$scale
translate <- swiss_poly$transform$translate
object_types <- lapply(swiss_objects,function(x){x$type})
sppolys <- lapply(swiss_objects[which(object_types=="Polygon")],topo_poly_to_sp_poly,scale,translate,arcs)
p2 <- Polygons(list(sppolys[[1]]),ID="a")
p3 <- SpatialPolygons(list(p2))
plot(p3)
}

