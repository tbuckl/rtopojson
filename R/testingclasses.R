#' spatial polygons topology
setClass("SpatialPolygonsTopology",
         representation(
           name="character",
           arcs="matrix",
           arc_indexes="list",
           type="character"),
         prototype(type="Polygon"))

setGeneric("fromtopojson",
          function (object, topojson) 
          {
            standardGeneric("fromtopojson")
          }
)

setMethod("fromtopojson", signature("SpatialPolygonsTopology"), 
          function(object,topojson) 
          {
          object.name <- topojson.name
          object.arcs <- do.call(rbind,ca.arcs[[1]])
          object_types <- lapply(topojson.geometries,function(x){x[[object.type]]})
          object.arc_indexes <- topojson.geometries[which(object_types==object.type)]
          }
  )

fromtopojson(polytest,ca)

polytest