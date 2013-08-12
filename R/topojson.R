#' container for TopoJSON JSON
setClass("topojson",
         representation(
           json="list",
           geometries="list",
           name="character",
           arcs="list",
           scale="list",
           translate="list")
)

#' Open a TopoJSON JSON file
#' @param an object of class 'topojson' 
#' @param file file location on disk
#' @return 'topojson' object with slots "name", "geometries, "arcs"
#' @examples
#' ca <- new("topojson")
#' open(ca,"inst/extdata/cali_nv_ariz.json")
#' print(ca.name)
setMethod("open",
    signature(con = "topojson"),
    function (con, file="") 
    {
      con.json = fromJSON(paste(readLines(file,warn=FALSE)))
      con.name = names(con.json$objects)
      con.geometries = con.json$objects[[con.name]]$geometries
      con.arcs = con.json$arcs
      con.scale = con.json$transform$scale
      con.translate = con.json$transform$translate
    }
)



