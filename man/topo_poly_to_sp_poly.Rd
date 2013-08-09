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
}

