library(sp)

#' Open a TopoJSON JSON file 
#' @param file file location on disk
#' @return 'topojson' object with slots "name", "geometries, "arcs", "translate","scale","json","file"
#' @examples
#' us <- Topojson$new(file="inst/extdata/cali_nv_ariz.json")
#' us$open()
#' print(us$translate)
#' print(us$geometries[[1]])
Topojson <- setRefClass("Topojson",
         fields = list(
           file="character",
           json="list",
           geometries="list",
           name="character",
           arcs="list",
           scale="vector",
           translate="vector",
           abs_arcs="matrix",
           sp_polygons="list"),
         methods = list(
           open = function ()
           {
             json <<- fromJSON(paste(readLines(file,warn=FALSE)))
             name <<- names(json$objects)
             geometries <<- json$objects[[name]]$geometries
             arcs <<- json$arcs
             scale <<- json$transform$scale
             translate <<- json$transform$translate
           },
           t2sp = function ()
           {
             object_types <- lapply(geometries,function(x){x$type})
             sppolys <- lapply(geometries[which(object_types=="Polygon")],topo_poly_to_sp_poly,scale,translate,arcs)
             sp_polygons <<- sppolys
           },
           plot = function ()
           {
            plotpolys(sp_polygons)
           }
         ))



