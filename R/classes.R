#' constructor for arcs
Arc <- function(x=NULL) {
  r <- structure(vector(mode="integer"), class="arc")
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





