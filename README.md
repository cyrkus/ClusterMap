# ClusterMap
Creates map clustering using this [algorythm](https://robots.thoughtbot.com/how-to-handle-large-amounts-of-data-on-maps) ported into Swift.

To build a QuadTree first conform any data structure to `ClusterMapLocation`.

Next conform the presenting controller to `ClusteMapDesignable`.

`ClusterMapDesignable` has two properties: `QuadTreeCoordinator` and `MKMapView`. 

On `ViewDidLoad` or elsewhere prior to setting the QuadTreeRegion call `buildQuadTree(mapView, locations)`. 
The default search area is set to the world. 

To update the QuadTreeRegion call `quadTreeRegionDidChange(_ animated: Bool)`
