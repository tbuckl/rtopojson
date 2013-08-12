\name{Topojson}
\alias{Topojson}
\title{Class for TopoJSON Specified Spatial Data}
\usage{
  Topojson(...)
}
\arguments{
  \item{file}{file location on disk}
}
\value{
  'topojson' object with slots "name", "geometries, "arcs",
  "translate","scale","json","file"
}
\description{
  "TopoJSON is an extension of GeoJSON. TopoJSON introduces
  a new type, "Topology", that contains GeoJSON objects. A
  topology has an objects map which indexes geometry
  objects by name. These are standard GeoJSON objects, such
  as polygons, multi-polygons and geometry collections.
  However, the coordinates for these geometries are stored
  in the topology's arcs array, rather than on each object
  separately. An arc is a sequence of points, similar to a
  line string; the arcs are stitched together to form the
  geometry. Lastly, the topology has a transform which
  specifies how to convert delta-encoded integer
  coordinates to their native values (such as longitude &
  latitude)." M.Bostock
  https://github.com/mbostock/topojson/wiki/Specification

  The appeal of this specification for R spatial users is
  that the specification reduces storage size (at the cost
  of higher retrieval time), and its possible applications
  in analysis and cartography.

  Few spatial formats support this type of storage of
  spatial data.  Of the few that do, their specification is
  not in current use or supported.  For example, the ESRI
  e00 file format also stores polygon arcs, however this
  file type has not been supported by ESRI in consumer
  products in decades.

  There are libraries to read from e00 for R, such as
  RArcInfo.  However, there is not an easy way to create
  and share new e00 files, except for ArcInfo users.  On
  the other hand, there is a topojson javascript library to
  encode shapefiles, csv's, and GeoJSON.
}
\examples{
t1 <- Topojson$new()
}

