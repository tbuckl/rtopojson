library("rjson")
library("bitops")

test_data <- "/Users/tom/topojson/test.json"
test_poly <- fromJSON(paste(readLines(test_data), collapse=""))

#swiss test data parsing
swiss_data <- "inst/extdata/swissborders.topojson"
swiss_poly <- fromJSON(paste(readLines(swiss_data), collapse=""))

swiss_objects <- swiss_poly$objects$"swiss-cantons"$geometries
swiss_arcs <- swiss_poly$arcs
single_swiss_object <- swiss_objects[[1]]

#value: returns a list of absolute coordinates 
#(often longitude,latitude) 
#arguments: takes an arc 
#(line-string of delta-encoded 
#integer coordinates)
#and (x,y) "scale" and (x,y) "translate" 
rel2abs <- function(arc, scale=Null, translate=Null) {
  if (!is.null(scale) & !is.null(translate)) {
    a <- 0
    b <- 0
    print("newloop")
    lapply(arc,function(point) {    
      a <<- a + point[[1]]
      b <<- b + point[[2]]
      x <- scale[1]*a + translate[1]
      y <- scale[2]*b + translate[2]
      c(x, y)})
  } else {
    c(arc[1], arc[2])
  }
}

bitflipper <- function(i) {
  if (i >= 0) {i = i} else {i = bitFlip(i)}
}

#takes an index,all_arcs,scale,translate
#returns topojson 
#returns list of absolute coordinates for all the objects arcs

#loop through arc_index, making array for object

arcs=swiss_arcs
scale=swiss_scale
translate=swiss_translate
arc_index <- swiss_objects[[3]]$arcs[[1]]

# from the inside out:
#1) flip bits for "the one's complement" (e.g. reversed arcs like -12)
#2) add +1 to the index b/c of R's list indexes
#3) subset all arcs from the total set for the object
#4) apply the transformation to each arc and output as list
abs_obj <- lapply(arcs[sapply(arc_index,bitflipper)+1],rel2abs,scale,translate)

#flip the arcs with negative indices
abs_obj[which(arc_index<0)] <- lapply(abs_obj[which(arc_index<0)],rev)

#from inside out:
#1)flatten list of arcs
#2)make a 2-dimensional matrix from them
#3)make an sp polygon class
p1 <- Polygon(do.call(rbind,unlist(abs_obj,recursive=FALSE)))

#plot the polygon
p2 <- Polygons(list(p1),ID="a")
p3 <- SpatialPolygons(list(p2))
plot(p3)



arc_index<0



#TODO:other test data

arc_index <- test_data$objects[[1]]$arcs
arcs <- test_poly$arcs


#yet more test data
us_data <- "inst/extdata/cali_nv_ariz.topojson"
us_poly <- fromJSON(paste(readLines(us_data), collapse=""))

#initial test data
json_file <- "inst/extdata/example.topojson"
json_data <- fromJSON(paste(readLines(json_file), collapse=""))

#example calls from sample data 1
aruba_arc_index <- json_data$objects$aruba$arcs
aruba_arcs <- json_data$arcs

#example of getting second element from each arc:
lapply(json_data$arcs[[1]],function(x) x[[2]])

#example extractions from parsed topojson
scale <- json_data$transform$scale
translate <- json_data$transform$translate
arcs <- json_data$arcs[[1]]

#apply arc translation to all arcs in example data 1
result <- lapply(arcs,rel2abs,scale=scale,translate=translate)

#make sp polygons from topojson
forobject <- function(objects,arcs,scale,translate) {
  
}


result <- lapply(swiss_arcs[[1]],rel2abs,scale=scale,translate=translate)
