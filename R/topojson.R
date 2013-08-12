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
           rel2abs = function (arc)
           {
             if (!is.null(scale) & !is.null(translate)) {
               a <- 0
               print(a)
               b <- 0
               print(b)
               lapply(arc,function(point) {    
                 a <- a + point[[1]]
                 b <- b + point[[2]]
                 x <- scale[1]*a + translate[1]
                 y <- scale[2]*b + translate[2]
                 c(x, y)})
             } else {
               c(arc[1], arc[2])
             } 
           },
           bitflipper = function(i) {
             if (i >= 0) {i = i} else {i = bitFlip(i)}
           },
           topo_poly_to_sp_poly = function(topojson_object) {
             
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
             # 3)make a matrix
             do.call(rbind,unlist(abs_obj,recursive=FALSE))
             
           }
           
           
         ))

us <- Topojson$new(file="inst/extdata/cali_nv_ariz.json")
us$open()
a <- us$topo_poly_to_sp_poly(us$geometries[[2]])




