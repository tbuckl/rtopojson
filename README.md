#rtopojson

The goal of this package is to allow R users to work with the TopoJSON specification. For more on the advantages of the TopoJSON specification see the [wiki for TopoJSON](https://github.com/mbostock/topojson/wiki).

For more on the R 'sp' package for working with spatial data see [the Comprehensive R Archive Network](http://cran.r-project.org/web/packages/sp/index.html)

##Functionality
Import TopoJSON Polygon objects to R SpatialPolygons 'sp' class.

Note that currently only TopoJSON of the type "Polygon" works.

##To Do:
* Support for Multipolygon, Line
* Native R Class/Type based on TopoJSON Specificaion
* Port methods (e.g. "neighbors") from TopoJSON JS
