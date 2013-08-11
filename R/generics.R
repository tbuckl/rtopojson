#' Given TopoJSON Object will determine type and output SP object
#' 
#' 
TopoToSp <- function(x,arcs) {
  UseMethod("TopoToSp", x)
}

TopoToSp.Arc <- function(x) {
  stop("Arcs do not contain object types like Polygon, MultiPolygon.  To translate individual arcs, try rel2abs.")
}

value.ArcIndex <- function(x) {
  stop("An ArcIndex do not contain object types like Polygon, MultiPolygon.  To translate individual arcs, try rel2abs.")
}

TopoToSp.Polygon <- function(x) {
  # The class of the return vector needs to be "FibonacciData".
  # We can do this by passing it to the constructor.
  topo_poly_to_sp_poly(c(tail(x, 1), ifelse(!length(x), 1, sum(x))))
}

value.FibonacciData <- function(x) {
  ifelse(length(x) == 0, 0, tail(x, 1))
}