## ClusterMap
Creates map clustering using this [Algorithm](https://robots.thoughtbot.com/how-to-handle-large-amounts-of-data-on-maps) ported into Swift.

ClusterMap uses [Carthage](https://github.com/Carthage/Carthage) for distribution.

ClusterMap is currently only available on iOS and requires 8.4

#To install this framework

Check your Carthage Version to make sure Carthage is installed locally:
`Carthage version`

Create a CartFile to manage your dependencies:
`Touch CartFile`

Open the Cartfile and add this as a dependency. (in OGDL):
`github "sevenapps/ClusterMap" "master"`

Update your project to include the framework:
`Carthage update --platform iOS`


#To uses this framework
To build a QuadTree first conform any data structure to `ClusterMapLocation`.

Next conform the presenting controller to `ClusteMapDesignable`.

`ClusterMapDesignable` has two properties: `QuadTreeCoordinator` and `MKMapView`.

On `ViewDidLoad` or elsewhere prior to setting the QuadTreeRegion call `buildQuadTree(mapView, locations)`.
The default search area is set to the world.

To update the QuadTreeRegion call `quadTreeRegionDidChange(_ animated: Bool)`
