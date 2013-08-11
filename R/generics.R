#' Given TopoJSON Object will determine type and output SP object
#' 
#' 
TopoToSp <- function(x,arcs) {
  UseMethod("TopoToSp", x, arcs)
}

TopoToSp.Arc <- function(x) {
  stop("Arcs do not contain object types like Polygon, MultiPolygon.  To translate individual arcs, try rel2abs.")
}

TopoToSp.ArcIndex <- function(x) {
  stop("An ArcIndex do not contain object types like Polygon, MultiPolygon.  To translate individual arcs, try rel2abs.")
}

rel2abs.Arc <- function(x,scale,translate) {
	UseMethod("rel2abs", x, scale, translate)
}

rel2abs.ArcIndex <- function(x,scale,translate) {
	UseMethod("rel2abs", x)
}

TopoToSp.Polygon <- function(x,scale,translate,arcs) {
  topo_poly_to_sp_poly(c(tail(x, 1), ifelse(!length(x), 1, sum(x))))
}

plot.TopoPolygon <- function(x) {

}




