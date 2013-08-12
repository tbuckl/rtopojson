setClass("topopolygons",
         representation(
           arcs="matrix",
           arc_indexes="list"
         )
)

setClass("topojson",
         representation(
          objects="list",
          name="character",
          arcs="list")
)

setClass("tjfile",
         representation(
           disklocation="character",
           name="character"),
)




ca <- new("topojson")
open(ca,"inst/extdata/cali_nv_ariz.json")



ca.json <- fromJSON(paste(readLines(us_data,warn=FALSE)))
ca.name <- names(ca.json$objects)
ca.geometries <- ca.json$objects[[ca.name]]$geometries
ca.arcs <- ca.json$arcs

