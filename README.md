#RTopoJSON
The goal of this package is to allow R users to work with the TopoJSON specification. For more on the advantages of the TopoJSON specification see the [wiki for TopoJSON](https://github.com/mbostock/topojson/wiki).

For more on the R 'sp' package for working with spatial data see [the Comprehensive R Archive Network](http://cran.r-project.org/web/packages/sp/index.html)

##Functionality
Import TopoJSON Polygon objects to R SpatialPolygons 'sp' class.

Import TopoJSON Polygon objects to R SpatialLines 'sp' class.

Find neighbors of arcs within a certain distance. 

Note that currently only TopoJSON of the type "Polygon" works.

##To Do:
* Support for Multipolygon, Line
* Native R Class/Type based on TopoJSON Specificaion
* Port methods (e.g. "neighbors") from TopoJSON JS

An Introduction to the **rtopojson** package
=======================================

Introduction
------------

This is an explanation of why and how one might use the **rtopojson** package.

Why You Might Use This Package
------------------------------

The appeal of this specification for R spatial users is that the specification reduces storage size (at the cost of higher retrieval time), and its possible applications in analysis and cartography.

Few spatial formats support this type of storage of spatial data.  Of the few that do, their specification is not in current use or supported.  For example, the ESRI e00 file format also stores polygon arcs, however this file type has not been supported by ESRI in consumer products in decades.

There are libraries to read from e00 for R, such as RArcInfo.  However, there is not an easy way to create and share new e00 files, except for ArcInfo users.  On the other hand, there is a topojson javascript library to encode shapefiles, csv's, and GeoJSON. 

How to Use the Package
----------------------

TopoJSON files are basically made up of an array of arcs and an array of objects, each of which contains a vector with an index for those arcs.  

We start by opening up a TopoJSON file and having a look at the arcs and objects.  A few TopoJSON files are included in the inst/data directory.  We will use one representing the states of California, Nevada and Arizona.  


```r
library(rtopojson)
```

```
## Loading required package: sp
```

```
## Loading required package: rjson
```

```r
library(bitops)
t <- Topojson$new()
t$open("/Users/tom/rtopojson/inst/extdata/cali_nv_ariz.json")
str(t$arcs[[1]][1:3])
```

```
## List of 3
##  $ : num [1:2] 6304 1298
##  $ : num [1:2] 2 11
##  $ : num [1:2] 25 22
```

       
Arcs are in delta-encoded integer coordinates.  

In addition, All objects are described by indexes:
       

```r
str(t$geometries[[1]])
```

```
## List of 2
##  $ type: chr "Polygon"
##  $ arcs:List of 1
##   ..$ : num [1:3] 0 1 2
```


To convert all polygons to their absolute coordinates 
and make them into Spatial Polygon(s), we can use:


```r
t$t2sp()
```

Here we see the first Polygon in absolute coordinates,
as a SpatialPolygon object.

Finally, we can plot all the Polygons in the TopoJSON file:


```r
t$plot()
```

```
## List of 1
##  $ :Formal class 'Polygon' [package "sp"] with 5 slots
##   .. ..@ labpt  : num [1:2] -111.7 34.3
##   .. ..@ area   : num 28.9
##   .. ..@ hole   : logi FALSE
##   .. ..@ ringDir: int 1
##   .. ..@ coords : num [1:398, 1:2] -115 -115 -115 -115 -115 ...
## NULL
## List of 1
##  $ :Formal class 'Polygon' [package "sp"] with 5 slots
##   .. ..@ labpt  : num [1:2] -116.7 39.4
##   .. ..@ area   : num 30
##   .. ..@ hole   : logi FALSE
##   .. ..@ ringDir: int 1
##   .. ..@ coords : num [1:222, 1:2] -115 -115 -115 -115 -115 ...
## NULL
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4.png) 

