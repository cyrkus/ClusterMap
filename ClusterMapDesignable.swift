//
//  ClusterDesignable.swift
//  QuadTree
//
//  Created by Aaron Dean Bikis on 3/3/17.
//  Copyright © 2017 7apps. All rights reserved.
//

import UIKit
import MapKit

/**
 To build a quad tree first conform any data structure to *ClusterMapLocation*.
 *Before building the QuadTree*: Instanciate an property instance of QuadTreeCoordinator, MKMapView and conform the presenting class with this protocol's methods.
 *On ViewDidLoad or elsewhere* call *buildQuadTree(mapView, locations)*
 *To update the QuadTreeRegion* call *quadTreeRegionDidChange(_ animated: Bool)*
*/
public protocol ClusterMapDesignable {
    
    var quadTreeCoordinator: CoordinateQuadTree! { get set }
    
    var mapView: MKMapView! { get set }
    
    /**
     parameters: 
     - mapview : MKMapView
     - locations: Array<ClusterMapLoctaion>
    */
    func buildQuadTree(withMapView mapView:MKMapView, locations:[ClusterMapLocation])
    
    /**
     Call this to update the quadTree region after the mapView region changed.
     It observes the mapView.visibleMapRect
    */
    func quadTreeRegionDidChange()
}

public extension ClusterMapDesignable {

    func buildQuadTree(withMapView mapView:MKMapView, locations:[ClusterMapLocation]) {
        guard quadTreeCoordinator != nil else { fatalError(ClusterMapErrors.quadTreeCoordinatorNotIntaciated.description) }
        quadTreeCoordinator.mapView = mapView
        let count = Int32(locations.count)
        quadTreeCoordinator.createNodeData(withCount: count)
        for i in 0..<locations.count {
            let node = quadTreeCoordinator.buildNode(withPointwithLat: locations[i].latitude,
                                                     withLong: locations[i].longitude,
                                                     andID: Int32(locations[i].id))
            quadTreeCoordinator.addNode(to: node, at: Int32(i))
        }
        quadTreeCoordinator.createRoot(withCount: count)
    }
    
    func quadTreeRegionDidChange() {
        DispatchQueue.global(qos: .background).async {
            let scale = Double(self.mapView.bounds.size.width) / self.mapView.visibleMapRect.size.width
            guard let annotations = self.quadTreeCoordinator.clusteredAnnotations(within: self.mapView.visibleMapRect, withZoomScale: scale) as? [ClusterAnnotation] else { return }
            self.updateMapViewAnnotations(with: annotations)
        }
    }
    
    
    func updateMapViewAnnotations(with annotations: [ClusterAnnotation]){
        let mapViewAnnot = mapView.annotations.filter({ $0 is ClusterAnnotation }) as! [ClusterAnnotation]
        let before = Set(mapViewAnnot)
        
        let after = Set(annotations)
        
        var toKeep = Set(before)
        toKeep = toKeep.intersection(after)
        
        var toAdd = Set(after)
        toAdd.subtract(toKeep)
        
        var toRemove = Set(before)
        toRemove.subtract(after)
        
        DispatchQueue.main.async {
            print("adding \(toAdd.count)")
            self.mapView.addAnnotations(Array(toAdd))
            print("removing \(toRemove.count)")
            self.mapView.removeAnnotations(Array(toRemove))
        }
    }
}
