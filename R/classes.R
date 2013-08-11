#' constructor for arcs
Arc <- function(x=NULL) {
  r <- structure(vector(mode="integer"), class="arc")
  if (!is.null(x)) {
    r <- x
  }
  r
}

#' constructor for Arcs
Arcs <- function(x=NULL) {
  r <-structure(matrix(ncol = 2), class="arcs")
  if (!is.null(x)) {
    r <- x
  }
  r
}

#' constructor for ArcIndex
ArcIndex <- function(x=NULL) {
  r <- structure(vector(mode="integer"), class="arcindex")
  if (!is.null(x)) {
    r <- x
  }
  r
}

TopoPolygon <- function(arc_index=NULL,arcs=NULL) {
  r <- structure(list(), class="topopolygon")
  if (!is.null(arc_index)) {
    r <- list(arc_index,arcs)
  }
  r
}





