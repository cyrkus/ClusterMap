//
//  ClusterAnnoation.swift
//  QuadTree
//
//  Created by Aaron Dean Bikis on 3/2/17.
//  Copyright © 2017 7apps. All rights reserved.
//

import MapKit
import Foundation

@objc public class ClusterAnnotation: NSObject, MKAnnotation {
    dynamic public var coordinate: CLLocationCoordinate2D
    public var objectIDs: [String]!
    public var count: UInt!
    
    public init(coordinate: CLLocationCoordinate2D, count:UInt) {
        self.coordinate = coordinate
        self.count = count
        super.init()
    }

    
    override public var hashValue: Int {
        get {
            let lat = String(self.coordinate.latitude)
            let long = String(self.coordinate.longitude)
            let toHash = lat.appending(long)
            return toHash.hashValue
        }
    }
}
